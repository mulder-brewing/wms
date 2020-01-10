ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!
require 'pp'
require_all 'test/test_custom/**/*.rb'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  DEFAULT_PASSWORD = "Password1$"

  # Shared return page title
  def wms_title (page_title)
    page_title + ' | Mulder WMS'
  end

  # This function helps verify that an object is invalid if a attribute is nil or empty string.
  def invalid_without(object, attribute)
    assert object.valid?
    object.send("#{attribute}=", nil)
    assert !object.valid?
    object.send("#{attribute}=", "")
    assert !object.valid?
  end

end

class ActionDispatch::IntegrationTest
  def xhr_redirect
    'window.location = "http://www.example.com/"'
  end

  def html_redirect
    "<html><body>You are being <a href=\"http://www.example.com/\">redirected</a>.</body></html>"
  end

  def xhr_not_found
    "hideModal('generic-modal');\n" +
    "alert_custom('warning','#{I18n.t("alert.record.not_found")}');\n"
  end

  def not_found?(response)
    case response.body
    when xhr_not_found
      return true
    when html_redirect
      follow_redirect!
      assert_select "div.alert-warning", I18n.t("alert.record.not_found")
      return true
    else
      return false
    end
  end

  # Log in as a particular user.
  def log_in_as(user, password = DEFAULT_PASSWORD, swapcase = false)
    username = user.username
    username.swapcase! if swapcase
    post login_path, params: { session: { username: username, password: password, } }
  end

  def log_out()
    delete logout_path
  end

  def redirected?(response)
    response.body == xhr_redirect || response.body == html_redirect
  end

  def log_in_if_user(user)
    log_in_as(user) if !user.nil?
  end

  # This function uses the NewTO to test the new modal.
  def new_to_test(to)
    log_in_if_user(to.user)
    get to.new_path, to.xhr_switch_params
    assert_equal to.validity, !redirected?(@response)
    assert_select "form", to.validity
    verify_visibles(to) if to.test_visibles?
  end

  # This function uses the CreateTO to test creating a record.
  def create_to_test(to)
    log_in_if_user(to.user)
    c = -> { post to.create_path, to.xhr_switch_params }
    if to.validity == true
      if to.check_count?
        assert_difference 'to.model_count', 1 do
          c.()
        end
      else
        c.()
      end
      verify_attributes(to) if to.test_attributes?
    else
      if to.check_count?
        assert_no_difference 'to.model_count' do
          c.()
        end
      else
        c.()
      end
      verify_visibles(to) if to.test_visibles?
    end
  end

  # This function uses the EditTO to test the edit modal.
  def edit_to_test(to)
    log_in_if_user(to.user)
    get to.edit_path, to.xhr_switch_params
    assert_equal to.validity, !redirected?(@response)
    assert_select "form", to.validity
    verify_visibles(to) if to.test_visibles?
  end

  # This function uses UpdateTO to test updating a record.
  def update_to_test(to)
    log_in_if_user(to.user)
    patch to.update_path, to.xhr_switch_params
    object = to.model
    old_object = object.dup
    object.reload
    if to.validity == true
      to.update_fields.each do |attribute|
        assert_not_equal old_object.send(attribute), object.send(attribute)
      end
      verify_attributes(to) if to.test_attributes?
    else
      to.update_fields.each do |attribute|
        if old_object.send(attribute) == nil
          assert_nil object.send(attribute)
        else
          assert_equal old_object.send(attribute), object.send(attribute)
        end
      end
      verify_visibles(to) if to.test_visibles?
    end
  end

  def not_found_to_test(to)
    log_in_if_user(to.user)
    nf = Proc.new {|x| assert_equal x, not_found?(@response) }
    if to.instance_of? UpdateTO
      path = to.update_path
      patch = Proc.new { patch path, xhr: true, params: to.params }
      patch.call
      nf.call(false)
      to.model.destroy
      patch.call
      nf.call(true)
    elsif to.instance_of? EditTO
      path = to.edit_path
      get = Proc.new { get path, xhr:true }
      get.call
      nf.call(false)
      to.model.destroy
      get.call
      nf.call(true)
    end
  end

  # This function uses IndexTo to test index
  def index_to_test(to)
    log_in_if_user(to.user)
    get to.index_path
    if to.validity == true
      assert_template to.index_template
      verify_visibles(to) if to.test_visibles?
    else
      assert redirected?(@response)
    end
  end

  # This function uses the DestroyTO to test deleting records.
  def destroy_modal_to_test(to)
    log_in_if_user(to.user)
    get to.path, to.xhr_switch_params
    assert_equal to.validity, !redirected?(@response)
    if to.validity == true
      message = I18n.t("modal.destroy.chicken_message", :to_delete=> to.to_delete)
      assert_match message, @response.body
    end
    verify_visibles(to) if to.test_visibles?
  end

  # This function uses NavbarTO to test navbar links.
  def navbar_to_test(to)
    al = Proc.new {|x| assert_select "a[href=?]", to.index_path, x }
    log_in_if_user(to.user)
    get root_path
    to.validity ? al.call(true) : al.call(false)
  end

  # This function helps verify things are/aren't visible in page, modal, form.
  def verify_visibles(to)
    vis = Proc.new { |to| to.visibles.each { |v| assert_select v.select, v.select_options } }
    if to.select_jquery_method.present?
      self.send(to.select_jquery_method) {
        vis.call(to)
      }
    else
      vis.call(to)
    end
  end

  # This function selects the modal and allows further selects to be yielded.
  def select_modal
    assert_select_jquery :html, "##{Modal::BaseModal::WRAPPER}" do
      assert_select "div##{Modal::BaseModal::ID}"
      yield
    end
  end

  # This function selects the form after a failed create or update.
  def select_form
    assert_select_jquery :replaceWith, "##{RecordForm.html_id}" do
      yield
    end
  end

  # This function helps verify model attributes after a successful create or update.
  def verify_attributes(to)
    case to
    when CreateTO
      model = to.model_last
    when UpdateTO
      model = to.model
      model.reload
    end
    to.attributes.each do |k, v|
      assert_equal v, model.send(k)
    end
  end

  def verify_enabled_filter_links(to)
    assert_select "main div.#{Page::IndexListPage::ACTION_BAR_CLASS} div.enabled-filter" do
        to.query = nil
        assert_select "a[href=?]", to.index_path
        to.query = :enabled
        assert_select "a[href=?]", to.index_path
        to.query = :disabled
        assert_select "a[href=?]", to.index_path
    end
  end

  # This function helps verify the response is an error warning message.
  def verify_alert_message(type, message)
    assert_match "alert_custom('#{type}', '#{message}')", @response.body
  end

  # This function helps verify a string or regex exists in the response.
  def verify_assert_match(string_or_regex)
    assert_match string_or_regex, @response.body
  end

  # This function helps verify a string or regex does not exist in the response.
  def verify_assert_no_match(string_or_regex)
    assert_no_match string_or_regex, @response.body
  end
end

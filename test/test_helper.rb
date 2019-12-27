ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!
require 'pp'
# Require my custom generic test object, then the subclasses
require "test_custom/TO/generic/includes.rb"
require "test_custom/TO/error/error_to.rb"
require "test_custom/TO/input/input_to.rb"
Dir.glob(Rails.root.join("test/test_custom/TO/input/sub/*.rb"), &method(:require))
require "test_custom/TO/generic/generic_to.rb"
require "test_custom/TO/generic/new_edit_to.rb"
require "test_custom/TO/generic/create_update_to.rb"
Dir.glob(Rails.root.join("test/test_custom/TO/generic/sub/*.rb"), &method(:require))

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

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
  def log_in_as(user, password = "Password1$", swapcase = false)
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
    verify_modal_title(to) if to.test_title?
    verify_modal_footer(to) if to.test_buttons? || to.test_timestamps?
    verify_form_inputs(to) if to.test_inputs?
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
      verify_errors(to) if to.test_errors?
      verify_form_inputs(to) if to.test_inputs?
    end
  end

  # This function uses the EditTO to test the edit modal.
  def edit_to_test(to)
    log_in_if_user(to.user)
    get to.edit_path, to.xhr_switch_params
    assert_equal to.validity, !redirected?(@response)
    assert_select "form", to.validity
    verify_modal_title(to) if to.test_title?
    verify_modal_footer(to) if to.test_buttons? || to.test_timestamps?
    verify_form_inputs(to) if to.test_inputs?
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
      verify_errors(to) if to.test_errors?
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
      if to.check_visibility?
        to.visible_y_records.each do |record|
          assert_select "tr##{record.table_row_id}"
        end
        to.visible_n_records.each do |record|
          assert_select "tr##{record.table_row_id}", false
        end
      end
      assert_select "header h3", to.title if to.test_title?
      assert_select "header a:match('href',?)", to.new_path if to.test_new?
      if to.test_enabled_filter?
        assert_select "main div.action-bar div.enabled-filter" do
            to.query = nil
            assert_select "a[href=?]", to.index_path
            to.query = :enabled
            assert_select "a[href=?]", to.index_path
            to.query = :disabled
            assert_select "a[href=?]", to.index_path
        end
      end
      if to.test_edit?
        to.visible_edit_records.each do |record|
          assert_select "table.index-table tr##{record.table_row_id} a[href=?]",
            edit_polymorphic_path(record), { :text => I18n.t("modal.edit") }
        end
      end
      if to.test_pagination?
        assert_select "main div.pagination-wrapper div.pagination-count",
          /#{to.model.class.where_company(to.user.company_id).count}/
      end
    else
      assert redirected?(@response)
    end
  end

  # This function uses NavbarTO to test navbar links.
  def navbar_to_test(to)
    al = Proc.new {|x| assert_select "a[href=?]", to.index_path, x }
    log_in_if_user(to.user)
    get root_path
    to.validity ? al.call(true) : al.call(false)
  end

  # This function selects the modal and allows further selects to be yielded.
  def select_modal
    assert_select_jquery :html, "##{ModalForm::GenericModal::WRAPPER}" do
      assert_select "div##{ModalForm::GenericModal::ID}"
      yield
    end
  end

  # This function selects the form after a failed create or update.
  def select_form
    assert_select_jquery :replaceWith, "##{ModalForm::GenericForm::ID}" do
      yield
    end
  end

  # This function helps verify the modal's title.
  def verify_modal_title(to)
    select_modal {
      modal_title = "div.modal-header h5.modal-title"
      assert_select modal_title, to.title
    }
  end

  # This function helps verify what's in the modal footer.
  def verify_modal_footer(to)
    select_modal {
      assert_select "div.modal-footer" do
        if to.test_buttons?
          assert_select "button", to.buttons.length
          if to.check_save_button?
            assert_select "button[type=submit]", I18n.t("modal.save")
          end
          if to.check_close_button?
            assert_select "button[data-dismiss=modal]", I18n.t("modal.close")
          end
        end
        if to.test_timestamps?
          count = to.timestamps_visible ? 1 : 0
          assert_select "a[href=?]", "#collapseTimestamps",
            { :text => I18n.t("timestamps.title"), :count => count }
        end
      end
    }
  end

  # This function helps verify form inputs.
  def verify_form_inputs(to)
    self.send(to.select_jquery_method) {
      assert_select "form" do
        to.inputs.each do |input|
          case input
          when SelectTO
            assert_select "select##{input.id}", input.visible? do
              assert_select "option", input.options_count if input.check_count?
              input.options.each do |option|
                assert_select "option[value=#{option.id}]",
                  { :text => option.label, :count => option.visible ? 1 : 0 }
              end
            end
          when InputTO
            assert_select "input##{input.id}", input.visible?
          end
        end
      end
    }
  end

  # This function helps verify form errors when a create or update fails.
  def verify_errors(to)
    to.error_to_array.each do |f|
      assert_match f.error_message, @response.body
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

  # This function helps tests to run related to getting new object page/moda with ajax.
  def new_object_modal_as(user, path, validity)
    log_in_if_user(user)
    get path, xhr:true
    assert_equal validity, !redirected?(@response)
    assert_select "form", validity
  end

  # This function helps tests to run related to creating a new object with ajax.
  def create_object_as(user, model, path, params, validity)
    log_in_if_user(user)
    if validity == true
      assert_difference 'model.count', 1 do
        post path, xhr: true, params: params
      end
    else
      assert_no_difference 'model.count' do
        post path, xhr: true, params: params
      end
    end
  end

  # This function helps tests to run related to getting the show object modal.
  def show_object_as(user, path, validity)
    log_in_if_user(user)
    get path, xhr:true
    assert_equal validity, !redirected?(@response)
  end

  # This function helps tests to run related to getting the edit object modal.
  def edit_object_as(user, path, redirected, form)
    log_in_if_user(user)
    get path, xhr:true
    if redirected
      assert redirected?(@response)
    end
    # assert_select "form", form
  end

  # This function helps tests to run related to updating objects.
  def update_object_as(user, object, path, params, attributes_to_compare, validity)
    log_in_if_user(user)
    patch path, xhr: true, params: params
    old_object = object.dup
    object.reload
    if validity == true
      attributes_to_compare.each do |attribute|
        assert_not_equal old_object.send(attribute), object.send(attribute)
      end
    else
      attributes_to_compare.each do |attribute|
        if old_object.send(attribute) == nil
          assert_nil object.send(attribute)
        else
          assert_equal old_object.send(attribute), object.send(attribute)
        end
      end
    end
  end

  # This function helps tests to run related to index of objects.
  def index_objects(user, path, template, validity, options = {})
    log_in_if_user(user)
    if options[:xhr]
      get path, xhr:true
    else
      get path
    end
    if validity == true
      assert_template template
    else
      assert redirected?(@response)
    end
  end

  # This function helps tests to run related to notification of when a stale object has been deleted.
  def check_if_object_deleted(user, controller_methods, hash, text, validity)
    log_in_if_user(user)
    controller_methods.each do |key, value|
      value.each do |key, value|
        case key
          when :get
            get value, xhr:true
          when :patch
            patch value, xhr: true, params: hash
        end
        if validity == true
          assert_match /#{text}/, @response.body
        else
          assert_no_match /#{text}/, @response.body
        end
      end
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

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!
require 'pp'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Shared return page title
  def wms_title (page_title)
    page_title + ' | Mulder WMS'
  end

end

class ActionDispatch::IntegrationTest
  def xhr_redirect
    'window.location = "http://www.example.com/"'
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
    xhr_redirect == response.body
  end

  def log_in_if_user(user)
    log_in_as(user) if !user.nil?
  end

  # This function helps tests to run related to getting new object page/moda with ajax.
  def new_object_modal_as(user, path, validity)
    log_in_if_user(user)
    get path, xhr:true
    assert_equal validity, !redirected?(@response)
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
  def edit_object_as(user, path, validity)
    log_in_if_user(user)
    get path, xhr:true
    assert_equal validity, !redirected?(@response)
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
        assert_equal old_object.send(attribute), object.send(attribute)
      end
    end
  end

  # This function helps tests to run related to index of objects.
  def index_objects(user, path, template, validity)
    log_in_if_user(user)
    get path
    if validity == true
      assert_template template
    else
      assert_redirected_to root_url
    end
  end

  # This function helps tests to run related to notification of when a stale object has been deleted.
  def check_if_object_deleted(user, paths, hash, text, validity)
    log_in_if_user(user)
    paths.each do |key, value|
      case key
        when :show
          get value, xhr:true
        when :update
          patch value, xhr: true, params: hash
        when :edit
          get value, xhr:true
      end
      if validity == true
        assert_match /#{text}/, @response.body
      else
        assert_no_match /#{text}/, @response.body
      end
    end
  end
end

require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  #this is tested more thoroughly by the login_logout integration test

  test "should get login page with correct title, login form, inputs" do
    get login_url
    assert_response :success
    assert_select "title", wms_title("Log In")
    assert_select "form"
    assert_select "form input[id=session_username]"
    assert_select "form input[id=session_password]"
    assert_select 'form input[type=submit][value="Log in"]'
  end

end

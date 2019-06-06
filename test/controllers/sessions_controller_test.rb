require 'test_helper'
require 'pp'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = users(:regular_user)
    @company_admin = users(:company_admin_user)
    @app_admin = users(:app_admin_user)
  end

  test "should get login page with correct title, login form, inputs" do
    get login_url
    assert_response :success
    assert_select "title", wms_title("Log In")
    assert_select "form"
    assert_select "form input[id=session_username]"
    assert_select "form input[id=session_password]"
    assert_select 'form input[type=submit][value="Log in"]'
  end

  test 'login as regular user, check available links, logout' do
    get root_path
    # Log In link should be there.
    assert_select "a[href=?]", "/login", true
    # Other links shouldn't be there.
    assert_select "a[href=?]", "/users/#{@regular_user.id}/edit", false
    assert_select "a[href=?]", "/logout", false
    assert_select "a[href=?]", "/companies", false
    assert_select "a[href=?]", "/users", false
    get login_path
    assert_template 'sessions/new'
    # try to log in with the wrong password
    log_in_as(@regular_user, "password")
    assert_template 'sessions/new'
    # log in with the right password
    log_in_as(@regular_user)
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/home'
    # Log In link should be gone now that the user is logged in.
    assert_select "a[href=?]", "/login", false
    # Name of the user's company should be in the .lead jumbotron.
    assert_select '.lead', 'Average Joes'
    #Check the available links are right for a regular user.
    assert_select "a[href=?]", "/companies", false
    assert_select "a[href=?]", "/users", false
    # These links should exist for a user of any type.
    assert_select "a[href=?]", "/users/#{@regular_user.id}/edit", true
    assert_select "a[href=?]", "/logout", true
    log_out
    assert_redirected_to root_url
  end

  test 'login as company admin user, check the links' do
    log_in_as(@company_admin)
    follow_redirect!
    #Check the available links are right for a admin user.
    assert_select "a[href=?]", "/companies", false
    assert_select "a[href=?]", "/users", true
  end

  test 'login as app admin user, check the links' do
    log_in_as(@app_admin)
    follow_redirect!
    #Check the available links are right for a admin user.
    assert_select "a[href=?]", "/companies", true
    assert_select "a[href=?]", "/users", true
  end

  test 'logged in user visiting login page should be redirected to home' do
    log_in_as(@regular_user)
    get login_path
    assert_redirected_to root_url
  end

  test "a disabled user should not be able to log in" do
    @regular_user.update_attribute(:enabled, false)
    log_in_as(@regular_user)
    assert_select "div.alert-danger", "Invalid username/password combination"
  end

  test "a user whose company has been disabled should not be able to log in" do
    @regular_user.company.update_attribute(:enabled, false)
    log_in_as(@regular_user)
    assert_select "div.alert-danger", "Invalid username/password combination"
  end

  test "a user should be able to log in when username case doesn't match" do
    log_in_as(@regular_user, "Password1$", true)
    assert_redirected_to root_url
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to the ability for a admin to become user.
  def become_user_as(user, become_user, validity)
    log_in_if_user(user)
    get become_user_path(id: become_user.id)
    follow_redirect!
    if validity == true
      assert_match /#{become_user.username}/, @response.body
      assert_match /#{become_user.id}/, @response.body
    else
      assert_no_match /#{become_user.username}/, @response.body
      assert_no_match /#{become_user.id}/, @response.body
    end
  end

  test "a logged out user should not be able to become user" do
    become_user_as(nil, @regular_user, false)
  end

  test "a regular user should not be able to become user" do
    become_user_as(@regular_user, @company_admin, false)
  end

  test "a company admin should not be able to become user" do
    become_user_as(@company_admin, @app_admin, false)
  end

  test "a app admin should be able to become user" do
    become_user_as(@app_admin, @company_admin, true)
  end
end

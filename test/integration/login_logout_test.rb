require 'test_helper'

class LoginLogoutTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = users(:regular_user)
    @company_admin = users(:company_admin_user)
    @app_admin = users(:app_admin_user)
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




end

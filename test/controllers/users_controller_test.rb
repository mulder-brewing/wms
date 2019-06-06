require 'test_helper'
require 'pp'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = users(:regular_user)
    @company_admin = users(:company_admin_user)
    @app_admin = users(:app_admin_user)
    @other_user = users(:other_company_user)
    @delete_me_user = users(:delete_me_user)
    @regular_user_company = @regular_user.company
    @company_admin_company = @company_admin.company
    @app_admin_company = @app_admin.company
    @other_company = @other_user.company
  end

  

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to getting new user page/modal.
  def new_user_modal(user, validity)
    log_in_if_user(user)
    get new_user_path, xhr:true
    assert_equal validity, !redirected?(@response)
  end

  test "only a app admin or company admin should get new user modal" do
    # try not logged in
    new_user_modal(nil, false)
    # try logged in as a regular user
    new_user_modal(@regular_user, false)
    # try logged in as a company admin user
    new_user_modal(@company_admin, true)
    # try logged in as a app admin (should work and get modal)
    new_user_modal(@app_admin, true)
    assert_match /create-modal/, @response.body
    assert_match /New User/, @response.body
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to creating a user.
  def create_user_as(user, username, company_id, validity)
    params = { user: { first_name: "Test", last_name: "User", username: username, password: "Password1$", company_admin: false, app_admin: false, company_id: company_id } }
    log_in_if_user(user)
    if validity == false
      assert_no_difference 'User.count' do
        post users_path, xhr: true, params: params
      end
    else
      assert_difference 'User.count', 1 do
        post users_path, xhr: true, params: params
      end
    end
  end


  test "only a app admin or company admin should be able to create a user" do
    # try not logged in
    create_user_as(nil, "test1", @regular_user_company.id, false)
    # try logged in as a regular user
    create_user_as(@regular_user, "test2",@regular_user_company.id, false)
    # try logged in as a company admin user
    create_user_as(@company_admin, "test3", @company_admin_company.id, true)
    # try logged in as a app admin
    create_user_as(@app_admin, "test4", @app_admin_company.id, true)
  end

  test "if a company admin tries to create a user in another company, created user will still be same company as admin." do
    create_user_as(@company_admin, "test1", @other_company.id, true)
    assert_equal @company_admin.company_id, User.find_by(username: "test1").company_id
  end

  test "app admin should be able to create user in other company" do
    create_user_as(@app_admin, "test1", @other_company.id, true)
    assert_equal @other_user.company_id, User.find_by(username: "test1").company_id
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to getting the show user page/modal.
  def show_user_as(user, show_user, validity)
    log_in_if_user(user)
    get user_path(show_user), xhr:true
    assert_equal validity, !redirected?(@response)
  end

  test "only a app admin or company admin should be able to see a user's information" do
    # try not logged in
    show_user_as(nil, @regular_user, false)
    # try logged in as a regular user
    show_user_as(@regular_user, @regular_user, false)
    # try logged in as a company admin user
    show_user_as(@company_admin, @company_admin, true)
    show_user_as(@company_admin, @regular_user, true)
    # try logged in as a app admin
    show_user_as(@app_admin, @app_admin, true)
    show_user_as(@app_admin, @company_admin, true)
  end

  test "a company admin should not be able to see a user's information from another company." do
    show_user_as(@company_admin, @other_user, false)
  end

  test "a app admin should be able to see user's information from another company" do
    show_user_as(@app_admin, @other_user, true)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to getting the edit user page/modal.
  def edit_user_as(user, edit_user, validity)
    log_in_if_user(user)
    get edit_user_path(edit_user), xhr:true
    assert_equal validity, !redirected?(@response)
  end

  test "only a logged in user should get the edit user modal for themself" do
    # try not logged in
    edit_user_as(nil, @regular_user, false)
    # try logged in as a regular user
    edit_user_as(@regular_user, @regular_user, true)
    # try logged in as a company admin user
    edit_user_as(@company_admin, @company_admin, true)
    # try logged in as a app admin (should work and get modal)
    edit_user_as(@app_admin, @app_admin, true)
  end

  test "a regular user should should not be able to edit other users" do
    edit_user_as(@regular_user, @company_admin, false)
    edit_user_as(@regular_user, @other_user, false)
  end

  test "a company admin should be able to edit a user in the same company." do
    edit_user_as(@company_admin, @regular_user, true)
  end

  test "a company admin should not be able to edit a user in another company" do
    edit_user_as(@company_admin, @other_user, false)
  end

  test "a app admin should be able to edit a user in the same company." do
    edit_user_as(@app_admin, @company_admin, true)
  end

  test "a app admin should be able to edit a user in another company" do
    edit_user_as(@app_admin, @other_user, true)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to updating users.
  def update_user_as(user, update_user, parameter, test_what, validity)
    params = { user: parameter }
    log_in_if_user(user)
    old_user = update_user.dup
    patch user_path(update_user), xhr: true, params: params
    update_user.reload
    case test_what
      when "email"
        if validity == true
          assert_equal parameter[:email], update_user.email
        else
          assert_not_equal parameter[:email], update_user.email
        end
      when "password"
        if validity == true
          assert_not_equal old_user.password_digest, update_user.password_digest
        else
          assert_equal old_user.password_digest, update_user.password_digest
        end
      when "names"
        if validity == true
          assert_equal parameter[:username], update_user.username
          assert_equal parameter[:first_name], update_user.first_name
          assert_equal parameter[:last_name], update_user.last_name
        else
          assert_equal old_user.username, update_user.username
          assert_equal old_user.first_name, update_user.first_name
          assert_equal old_user.last_name, update_user.last_name
        end
      when "enabled"
        if validity == true
          assert_equal parameter[:enabled], update_user.enabled
          assert_equal parameter[:company_admin], update_user.company_admin
        else
          assert_equal old_user.enabled, update_user.enabled
          assert_equal old_user.company_admin, update_user.company_admin
        end
      when "app_admin"
        if validity == true
          assert_equal parameter[:app_admin], update_user.app_admin
        else
          assert_equal !parameter[:app_admin], update_user.app_admin
        end
    end

  end

  # ----------------------------------------------------------------------------
  # test who can and can't update email addresses
  email_hash = { email: "updated@updated.com" }
  test "a logged out user should not be able to update a email address" do
    update_user_as(nil, @regular_user, email_hash, "email", false)
  end

  test "all logged in users should be able to update their email" do
    # try logged in as a regular user
    update_user_as(@regular_user, @regular_user, email_hash, "email", true)
    # try logged in as a company admin user
    update_user_as(@company_admin, @company_admin, email_hash, "email", true)
    # try logged in as a app admin
    update_user_as(@app_admin, @app_admin, email_hash, "email", true)
  end

  test "a regular use should not be able to update anyone elses email address" do
    update_user_as(@regular_user, @company_admin, email_hash, "email", false)
    update_user_as(@regular_user, @app_admin, email_hash, "email", false)
    update_user_as(@regular_user, @other_user, email_hash, "email", false)
  end

  test "a company admin should be able to update email of another user in same company" do
    update_user_as(@company_admin, @regular_user, email_hash, "email", true)
  end

  test "a company admin should not be able to update email of user in another company" do
    update_user_as(@company_admin, @other_user, email_hash, "email", false)
  end

  test "app admin should be able to update email of any user" do
    update_user_as(@app_admin, @company_admin, email_hash, "email", true)
    update_user_as(@app_admin, @other_user, email_hash, "email", true)
  end

  # ----------------------------------------------------------------------------
  # test who can and can't update passwords
  password_hash = { password: "NewPassword123$" }
  test "a logged out user should not be able to update a password" do
    update_user_as(nil, @regular_user, password_hash, "password", false)
  end

  test "all users should be able to update their own password" do
    # try logged in as a regular user
    update_user_as(@regular_user, @regular_user, password_hash, "password", true)
    # try logged in as a company admin user
    update_user_as(@company_admin, @company_admin, password_hash, "password", true)
    # try logged in as a app admin
    update_user_as(@app_admin, @app_admin, password_hash, "password", true)
  end

  test "only a company admin or app admin should be able to update another user's password" do
    # try logged in as a regular user
    update_user_as(@regular_user, @company_admin, password_hash, "password", false)
    # try logged in as a company admin user
    update_user_as(@company_admin, @regular_user, password_hash, "password", true)
    # try logged in as a app admin
    update_user_as(@app_admin, @regular_user, password_hash, "password", true)
  end

  test "a company admin should not be able to update the password of a user outside it's company" do
    update_user_as(@company_admin, @other_user, password_hash, "password", false)
  end

  test "a app admin should be able to update the password of any user in any company" do
    update_user_as(@app_admin, @other_user, password_hash, "password", true)
  end

  # ----------------------------------------------------------------------------
  # test who can and can't update username, first_name, and last_name.
  names_hash = { username: "updated", first_name: "updated", last_name: "updated" }
  test "a logged out user should not be able to update username or name of any user." do
    update_user_as(nil, @regular_user, names_hash, "names", false)
  end

  test "a regular user should not be able to update username or name of any user" do
    update_user_as(@regular_user, @regular_user, names_hash, "names", false)
    update_user_as(@regular_user, @company_admin, names_hash, "names", false)
    update_user_as(@regular_user, @app_admin, names_hash, "names", false)
    update_user_as(@regular_user, @other_user, names_hash, "names", false)
  end

  test "a company admin should be able to update own username and name" do
    update_user_as(@company_admin, @company_admin, names_hash, "names", true)
  end

  test "a company admin should be able to update username and name of other users in same company" do
    update_user_as(@company_admin, @regular_user, names_hash, "names", true)
  end
  test "a company admin should not be able to update username and name of users in other company" do
    update_user_as(@company_admin, @other_user, names_hash, "names", false)
  end

  test "app admin should be able to update own username and name" do
    update_user_as(@app_admin, @app_admin, names_hash, "names", true)
  end

  test "app admin should be able to update username and name of users in same company" do
    update_user_as(@app_admin, @company_admin, names_hash, "names", true)
  end

  test "app admin should be able to update username and name of users in other company" do
    update_user_as(@app_admin, @other_user, names_hash, "names", true)
  end


  # ----------------------------------------------------------------------------
  # test who can and can't update enabled and company admin booleans
  disable_and_become_admin = { enabled: false, company_admin: true }
  disable_and_lose_admin = { enabled: false, company_admin: false }
  test "a logged out user shouldn't be able to update enabled or admin" do
    update_user_as(nil, @regular_user, disable_and_become_admin, "enabled", false)
    update_user_as(nil, @company_admin, disable_and_lose_admin, "enabled", false)
    update_user_as(nil, @app_admin, disable_and_lose_admin, "enabled", false)
  end

  test "a regular user shouldn't be able to update enabled or admin" do
    update_user_as(@regular_user, @regular_user, disable_and_become_admin, "enabled", false)
    update_user_as(@regular_user, @company_admin, disable_and_lose_admin, "enabled", false)
    update_user_as(@regular_user, @app_admin, disable_and_lose_admin, "enabled", false)
  end

  test "a company admin should be able to update enabled or admin for users in same company" do
    update_user_as(@company_admin, @regular_user, disable_and_become_admin, "enabled", true)
    update_user_as(@company_admin, @app_admin, disable_and_lose_admin, "enabled", true)
  end

  test "a company admin should not be able to update enabled or admin for users in another company" do
    update_user_as(@company_admin, @other_user, disable_and_become_admin, "enabled", false)
  end

  test "a app admin should be able to update enabled or admin for users in any company" do
    update_user_as(@app_admin, @other_user, disable_and_become_admin, "enabled", true)
    update_user_as(@app_admin, @company_admin, disable_and_lose_admin, "enabled", true)
  end

  test "a app admin shouldn't be able to disable or unadmin self" do
    update_user_as(@app_admin, @app_admin, disable_and_lose_admin, "enabled", false)
  end

  test "a company admin shouldn't be able to disable or unadmin self" do
    update_user_as(@company_admin, @company_admin, disable_and_lose_admin, "enabled", false)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to index of users.
  def index_users(user, validity)
    log_in_if_user(user)
    get users_path
    if validity == true
      assert_template 'users/index'
    else
      assert_redirected_to root_url
    end
  end

  test "a logged out user should not get the user index page." do
    index_users(nil, false)
  end

  test "a regular user should not get the user index page." do
    index_users(@regular_user, false)
  end

  test "a company admin should get the user index page and should only get users from own company except self." do
    index_users(@company_admin, true)
    # should see these users from same company
    assert_select "tr#user_#{@regular_user.id}"
    assert_select "tr#user_#{@app_admin.id}"
    # should not see self
    assert_select "tr#user_#{@company_admin.id}", false
    # should not see users from other companies
    assert_select "tr#user_#{@other_user.id}", false
    assert_select "tr#user_#{@delete_me_user.id}", false
  end

  test "a app admin should get the user index page and should get all users except self" do
    index_users(@app_admin, true)
    # should see these users from same company
    assert_select "tr#user_#{@regular_user.id}"
    assert_select "tr#user_#{@company_admin.id}"
    assert_select "tr#user_#{@other_user.id}"
    assert_select "tr#user_#{@delete_me_user.id}"
    # should not see self
    assert_select "tr#user_#{@app_admin.id}", false
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # test for app_admin should not be updated through the web.
  become_app_admin = { app_admin: true }
  test "no user should be able to become app admin through the web" do
    update_user_as(nil, @regular_user, become_app_admin, "app_admin", false)
    update_user_as(@regular_user, @regular_user, become_app_admin, "app_admin", false)
    update_user_as(@company_admin, @company_admin, become_app_admin, "app_admin", false)
    update_user_as(@app_admin, @company_admin, become_app_admin, "app_admin", false)
  end











end

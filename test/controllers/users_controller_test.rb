require 'test_helper'
require 'pp'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = users(:regular_user)
    @company_admin = users(:company_admin_user)
    @app_admin = users(:app_admin_user)
    @other_user = users(:other_company_user)
    @delete_me_user = users(:delete_me_user)
    @delete_me_admin = users(:delete_me_admin)
    @regular_user_company = @regular_user.company
    @company_admin_company = @company_admin.company
    @app_admin_company = @app_admin.company
    @other_company = @other_user.company
    @averagejoe_access_policy = access_policies(:average_joe_access_policy_everything)
    @other_access_policy = access_policies(:other_access_policy_everything)

    @new = User.new
    @ph = { first_name: "Test", last_name: "User", username: "new_user",
      password: "Password1$", company_admin: false, app_admin: false,
      access_policy_id: @averagejoe_access_policy.id }
    @other_admin = users(:other_company_admin)
  end

  # ----------------------------------------------------------------------------
  # Tests link in navbar.

  test "logged out user can't see the link" do
    to = NavbarTO.new(nil, @new, false)
    to.query = :enabled
    to.test(self)
  end

  test "regular user can't see the link" do
    to = NavbarTO.new(@regular_user, @new, false)
    to.query = :enabled
    to.test(self)
  end

  test "company admin can see the link" do
    to = NavbarTO.new(@company_admin, @new, true)
    to.query = :enabled
    to.test(self)
  end

  test "app admin can see the link" do
    to = NavbarTO.new(@app_admin, @new, true)
    to.query = :enabled
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for new modal.

  test "logged out user can't get new modal" do
    NewTO.new(nil, @new, false).test(self)
  end

  test "a regular user can't get new modal" do
    NewTO.new(@regular_user, @new, false).test(self)
  end

  test "new modal title" do
    to = NewTO.new(@company_admin, @new, true)
    to.test_title = true
    to.test(self)
  end

  test "new modal buttons" do
    to = NewTO.new(@company_admin, @new, true)
    to.add_save_button
    to.add_close_button
    to.test(self)
  end

  test "new modal timestamps aren't visible" do
    to = NewTO.new(@company_admin, @new, true)
    to.timestamps_visible = false
    to.test(self)
  end

  test "a company admin can get new modal" do
    NewTO.new(@company_admin, @new, true).test(self)
  end

  test "a app admin can get new modal" do
    NewTO.new(@app_admin, @new, true).test(self)
  end

  test "the enable/disable switch should not be visible on the new modal" do
    to = NewTO.new(@company_admin, @new, true)
    to.test_enabled = true
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for creating a record.



  test "a logged out user can't create" do
    CreateTO.new(nil, @new, @ph, false).test(self)
  end

  test "a regular user can't create" do
    CreateTO.new(@regular_user, @new, @ph, false).test(self)
  end

  test "a company admin can create" do
    CreateTO.new(@company_admin, @new, @ph, true).test(self)
  end

  test "a app admin can create" do
    CreateTO.new(@app_admin, @new, @ph, true).test(self)
  end

  test "company admin can only create own company user" do
    to = CreateTO.new(@company_admin, @new, @ph, true)
    to.merge_params_hash({ company_id: @other_admin.company_id })
    to.test_company_id = true
    to.test(self)
  end

  test "app admin can create user in any company" do
    to = CreateTO.new(@app_admin, @new, @ph, true)
    to.merge_params_hash({ company_id: @other_admin.company_id })
    to.params_hash[:access_policy_id] = @other_access_policy.id
    to.test_company_id = true
    to.expected_company_id = @other_admin.company_id
    to.test(self)
  end

  test "app admin can't create user with mismatch access policy" do
    to = CreateTO.new(@app_admin, @new, @ph, false)
    to.merge_params_hash({ company_id: @other_admin.company_id })
    to.add_error_to ErrorTO.new(:does_not_belong, :access_policy_id)
    to.test(self)
  end

  test "record should be enabled by default when it's created" do
    to = CreateTO.new(@company_admin, @new, @ph, true)
    to.test_enabled_default = true
    to.test(self)
  end

  test "username should be unique across all companies" do
    CreateTO.new(@company_admin, @new, @ph, true).test(self)
    to = CreateTO.new(@other_admin, @new, @ph, false)
    to.add_error_to ErrorTO.new(:unique, :username)
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for edit modal

  test "logged out user can't get edit modal" do
    EditTO.new(nil, @regular_user, false).test(self)
  end

  test "regular user can edit self" do
    EditTO.new(@regular_user, @regular_user, true).test(self)
  end

  test "regular user can't edit others" do
    EditTO.new(@regular_user, @company_admin, false).test(self)
  end

  test "edit modal title" do
    to = EditTO.new(@regular_user, @regular_user, true)
    to.test_title = true
    to.test(self)
  end

  test "edit modal buttons" do
    to = EditTO.new(@regular_user, @regular_user, true)
    to.add_save_button
    to.add_close_button
    to.test(self)
  end

  test "edit modal timestamps are visible" do
    to = EditTO.new(@regular_user, @regular_user, true)
    to.timestamps_visible = true
    to.test(self)
  end

  test "company admin can edit self" do
    EditTO.new(@company_admin, @company_admin, true).test(self)
  end

  test "company admin can edit company user" do
    EditTO.new(@company_admin, @regular_user, true).test(self)
  end

  test "company admin can't edit other company user" do
    EditTO.new(@company_admin, @other_user, false).test(self)
  end

  test "app admin can edit self" do
    EditTO.new(@app_admin, @app_admin, true).test(self)
  end

  test "app admin can edit company user" do
    EditTO.new(@app_admin, @regular_user, true).test(self)
  end

  test "app admin can edit other company user" do
    EditTO.new(@app_admin, @other_user, true).test(self)
  end

  test "the enable/disable switch is visible when editing user" do
    to = EditTO.new(@company_admin, @regular_user, true)
    to.test_enabled = true
    to.test(self)
  end

  test "the enable/disable switch should not be visible if editing self" do
    to = EditTO.new(@company_admin, @company_admin, true)
    to.test_enabled = true
    to.enabled_present = false
    to.test(self)
  end

  test "the admin checkbox is visible when editing user" do
    to = EditTO.new(@company_admin, @regular_user, true)
    input = InputTO.new(@regular_user.form_input_id(:company_admin))
    to.add_input(input)
    to.test(self)
  end

  test "the admin checkbox isn't when editing self" do
    to = EditTO.new(@company_admin, @company_admin, true)
    input = InputTO.new(@company_admin.form_input_id(:company_admin), false)
    to.add_input(input)
    to.test(self)
  end

  test "user is warned about a deleted/not found record for edit modal" do
    to = EditTO.new(@company_admin, @regular_user, nil)
    to.test_nf(self)
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
      assert_template Page::IndexListPage::INDEX_HTML_PATH
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
    assert_select "tr##{@regular_user.table_row_id}"
    assert_select "tr##{@app_admin.table_row_id}"
    # should not see self
    assert_select "tr##{@company_admin.table_row_id}", false
    # should not see users from other companies
    assert_select "tr##{@other_user.table_row_id}", false
    assert_select "tr##{@delete_me_user.table_row_id}", false
  end

  test "a app admin should get the user index page and should get all users except self" do
    index_users(@app_admin, true)
    # should see these users from same company
    assert_select "tr##{@regular_user.table_row_id}"
    assert_select "tr##{@company_admin.table_row_id}"
    assert_select "tr##{@other_user.table_row_id}"
    assert_select "tr##{@delete_me_user.table_row_id}"
    # should not see self
    assert_select "tr##{@app_admin.table_row_id}", false
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

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # tests for reset password functionality

  def reset_password_as(user, reset_user, test, parameter, validity)
    params = { user: parameter }
    log_in_if_user(user)
    patch user_path(reset_user), xhr: true, params: params
    reset_user.reload
    if test == "password_reset_boolean"
      # validity true means user has been flagged for reset password.
      if validity == true
        assert_equal reset_user.password_reset, true
      # validity false means user is not flagged for reset password.
      else
        assert_equal reset_user.password_reset, false
      end
    end
  end

  test "logged in user changing their own password should not set password reset flag to true" do
    reset_password_as(@regular_user, @regular_user, "password_reset_boolean", password_hash, false)
    reset_password_as(@company_admin, @company_admin, "password_reset_boolean", password_hash, false)
    reset_password_as(@app_admin, @app_admin, "password_reset_boolean", password_hash, false)
  end

  test "if a admin changes another user's password, that user's password reset flag should become true" do
    reset_password_as(@app_admin, @company_admin, "password_reset_boolean", password_hash, true)
    reset_password_as(@company_admin, @regular_user, "password_reset_boolean", password_hash, true)
  end

  test "A newly created user should have it's password_reset flag set to true" do
    new_user = User.create!(company: @company_admin_company, first_name: 'New',
      last_name: 'User', username: 'new_user_for_test789', password: 'Password1$',
      current_user: "seed", access_policy_id: @averagejoe_access_policy.id )
    assert new_user.password_reset == true
  end

  password_hash_2 = { password: "NewPassword123456$#2" }

  test "Monster test that checks the full flow of a user's password being reset and that user resetting it." do
    reset_password_as(@app_admin, @company_admin, "password_reset_boolean", password_hash, true)
    log_in_as(@company_admin, password_hash[:password])
    # There's 2 redirects because by default logged in redirects to root, then when password_reset is true, you get redirected to the update password page.
    follow_redirect!
    assert_redirected_to update_password_user_url(@company_admin)
    follow_redirect!
    # Should be 2 links, one being the Mulder WMS logo top left, the other being the log out link.
    assert_select 'a[href]', 2
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', root_path
    assert_select "form"
    assert_select "form input[id=user_password]"
    assert_select "form input[id=user_password_confirmation]"
    assert_select 'form input[type=submit][value="Update Password"]'
    # trying to load other TMS pages should redirect the user back to update password.
    get root_path
    assert_redirected_to update_password_user_url(@company_admin)
    get users_path
    assert_redirected_to update_password_user_url(@company_admin)
    get edit_user_path(@company_admin)
    assert_redirected_to update_password_user_url(@company_admin)
    # user should not be able to use the same password they logged in with as their new updated password.
    assert_no_changes '@company_admin.password_digest' do
      patch update_password_commit_user_path(@company_admin), params: { user: password_hash }
      @company_admin.reload
    end
    assert_template 'users/update_password'
    assert_select 'div.invalid-feedback', "Password cannot be the same as it is right now"
    # user should be able to update their password with a new password and their password_reset should now be false.
    assert_changes '@company_admin.password_digest' do
      patch update_password_commit_user_path(@company_admin), params: { user: password_hash_2 }
      @company_admin.reload
    end
    assert @company_admin.password_reset == false
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'div.alert-success', "Password successfully updated!"
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # tests for deleted user alerts on show, edit, update.

  def check_if_user_deleted(user, user_to_test, try, validity)
    log_in_if_user(user)
    case try
      when "update"
        patch user_path(user_to_test), xhr: true, params: { user: { email: "updated@updated.com" } }
      when "edit"
        get edit_user_path(user_to_test), xhr:true
    end
    if validity == true
      assert_match /Record not found/, @response.body
    else
      assert_no_match /Record not found/, @response.body
    end
  end

  test "if a user is deleted and a user trys to show, edit, or update that user, they are warned the user no longer exists." do
    check_if_user_deleted(@delete_me_admin, @delete_me_user, "update", false)
    check_if_user_deleted(@delete_me_admin, @delete_me_user, "edit", false)
    @delete_me_user.destroy
    check_if_user_deleted(@delete_me_admin, @delete_me_user, "update", true)
    check_if_user_deleted(@delete_me_admin, @delete_me_user, "edit", true)
  end

















end

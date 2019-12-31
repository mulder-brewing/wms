require 'test_helper'
require 'pp'

class Auth::UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = auth_users(:regular_user)
    @company_admin = auth_users(:company_admin_user)
    @app_admin = auth_users(:app_admin_user)
    @other_admin = auth_users(:other_company_admin)
    @other_user = auth_users(:other_company_user)
    @delete_me_user = auth_users(:delete_me_user)

    @new = Auth::User.new

    @averagejoe_access_policy = access_policies(:average_joe_access_policy_everything)
    @other_access_policy = access_policies(:other_access_policy_everything)

    @ph = { first_name: "Test", last_name: "User", username: "new_user",
      password: "Password1$", company_admin: false, app_admin: false,
      access_policy_id: @averagejoe_access_policy.id }
    @pu = { password: "NewPassword123$",
      password_confirmation: "NewPassword123$" }
    @pu2 = { password: "NewPassword123456$#2",
      password_confirmation: "NewPassword123456$#2" }

    @email = [:email]
    @password = [:password_digest]
    @names = [:first_name, :last_name, :username]
    @enabled_admin = [:enabled, :company_admin]
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

  test "a company admin can get new modal" do
    NewTO.new(@company_admin, @new, true).test(self)
  end

  test "company admin field visibility new modal" do
    to = NewTO.new(@company_admin, @new, true)
    to.add_input(SelectTO.new(@new.form_input_id(:company_id), false))
    to.add_input(InputTO.new(@new.form_input_id(:first_name)))
    to.add_input(InputTO.new(@new.form_input_id(:last_name)))
    to.add_input(InputTO.new(@new.form_input_id(:email)))
    to.add_input(InputTO.new(@new.form_input_id(:username)))
    to.add_input(InputTO.new(@new.form_input_id(:password)))
    to.add_input(InputTO.new(@new.form_input_id(:password_confirmation)))
    to.add_input(InputTO.new(@new.form_input_id(:send_email)))
    to.add_input(SelectTO.new(@new.form_input_id(:access_policy_id)))
    to.add_input(InputTO.new(@new.form_input_id(:company_admin)))
    to.add_input(InputTO.new(@new.form_input_id(:enabled), false))
    to.test(self)
  end

  test "access policy selector has enabled policies for company admin" do
    to = NewTO.new(@company_admin, @new, true)
    select = SelectTO.new(@new.form_input_id(:access_policy_id))
    select.options_count = AccessPolicy
      .enabled_where_company(@company_admin.company_id).count
    to.add_input(select)
    to.test(self)
  end

  test "access policy selector doesn't have disabled policies" do
    to = NewTO.new(@company_admin, @new, true)
    @averagejoe_access_policy.update_column(:enabled, false)
    select = SelectTO.new(@new.form_input_id(:access_policy_id))
    select.add_option(@averagejoe_access_policy.description,
                      @averagejoe_access_policy.id, false)
    to.add_input(select)
    to.test(self)
  end

  test "a app admin can get new modal" do
    NewTO.new(@app_admin, @new, true).test(self)
  end

  test "app admin field visibility new modal" do
    to = NewTO.new(@app_admin, @new, true)
    to.add_input(SelectTO.new(@new.form_input_id(:company_id)))
    to.add_input(InputTO.new(@new.form_input_id(:first_name)))
    to.add_input(InputTO.new(@new.form_input_id(:last_name)))
    to.add_input(InputTO.new(@new.form_input_id(:email)))
    to.add_input(InputTO.new(@new.form_input_id(:username)))
    to.add_input(InputTO.new(@new.form_input_id(:password)))
    to.add_input(InputTO.new(@new.form_input_id(:password_confirmation)))
    to.add_input(InputTO.new(@new.form_input_id(:send_email)))
    to.add_input(SelectTO.new(@new.form_input_id(:access_policy_id)))
    to.add_input(InputTO.new(@new.form_input_id(:company_admin)))
    to.add_input(InputTO.new(@new.form_input_id(:enabled), false))
    to.test(self)
  end

  test "access policy selector is empty for app admin" do
    to = NewTO.new(@app_admin, @new, true)
    select = SelectTO.new(@new.form_input_id(:access_policy_id))
    select.options_count = 0
    to.add_input(select)
    to.test(self)
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
    to.attributes = { :company_id => @company_admin.company_id }
    to.test(self)
  end

  test "app admin can create user in any company" do
    to = CreateTO.new(@app_admin, @new, @ph, true)
    to.merge_params_hash({ company_id: @other_admin.company_id })
    to.params_hash[:access_policy_id] = @other_access_policy.id
    to.attributes = { :company_id => @other_admin.company_id }
    to.test(self)
  end

  test "access policy select should have options for record's company" do
    to = CreateTO.new(@app_admin, @new, @ph, false)
    to.merge_params_hash({ company_id: @other_admin.company_id })
    # Setting this to nil so create fails.
    to.params_hash[:access_policy_id] = nil
    select = SelectTO.new(@new.form_input_id(:access_policy_id))
    select.add_option(@other_access_policy.description,
                      @other_access_policy.id,
                      true)
    select.options_count = AccessPolicy
      .enabled_where_company(@other_access_policy.company_id).count
    to.add_input(select)
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
    to.attributes = { :enabled => true }
    to.test(self)
  end

  test "username should be unique across all companies" do
    CreateTO.new(@company_admin, @new, @ph, true).test(self)
    to = CreateTO.new(@other_admin, @new, @ph, false)
    to.add_error_to ErrorTO.new(:unique, :username)
    to.test(self)
  end

  test "password_reset flag is true when user created" do
    to = CreateTO.new(@company_admin, @new, @ph, true)
    to.attributes = { :password_reset => true }
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

  test "company admin field visibility" do
    to = EditTO.new(@company_admin, @regular_user, true)
    to.add_input(InputTO.new(@new.form_input_id(:company_id), false))
    to.add_input(InputTO.new(@new.form_input_id(:first_name)))
    to.add_input(InputTO.new(@new.form_input_id(:last_name)))
    to.add_input(InputTO.new(@new.form_input_id(:email)))
    to.add_input(InputTO.new(@new.form_input_id(:username)))
    to.add_input(InputTO.new(@new.form_input_id(:password)))
    to.add_input(InputTO.new(@new.form_input_id(:password_confirmation)))
    to.add_input(InputTO.new(@new.form_input_id(:send_email)))
    to.add_input(SelectTO.new(@new.form_input_id(:access_policy_id)))
    to.add_input(InputTO.new(@new.form_input_id(:company_admin)))
    to.add_input(InputTO.new(@new.form_input_id(:enabled)))
    to.test(self)
  end

  test "regular user field visibility" do
    to = EditTO.new(@regular_user, @regular_user, true)
    to.add_input(InputTO.new(@new.form_input_id(:company_id), false))
    to.add_input(InputTO.new(@new.form_input_id(:first_name), false))
    to.add_input(InputTO.new(@new.form_input_id(:last_name), false))
    to.add_input(InputTO.new(@new.form_input_id(:email)))
    to.add_input(InputTO.new(@new.form_input_id(:username), false))
    to.add_input(InputTO.new(@new.form_input_id(:password)))
    to.add_input(InputTO.new(@new.form_input_id(:password_confirmation)))
    to.add_input(InputTO.new(@new.form_input_id(:send_email), false))
    to.add_input(SelectTO.new(@new.form_input_id(:access_policy_id), false))
    to.add_input(InputTO.new(@new.form_input_id(:company_admin), false))
    to.add_input(InputTO.new(@new.form_input_id(:enabled), false))
    to.test(self)
  end

  test "the enable/disable switch isn't visible when editing self" do
    to = EditTO.new(@company_admin, @company_admin, true)
    input = InputTO.new(@regular_user.form_input_id(:enabled), false)
    to.add_input(input)
    to.test(self)
  end

  test "the admin checkbox isn't visible when editing self" do
    to = EditTO.new(@company_admin, @company_admin, true)
    input = InputTO.new(@company_admin.form_input_id(:company_admin), false)
    to.add_input(input)
    to.test(self)
  end

  test "the send email isn't visible when editing self" do
    to = EditTO.new(@company_admin, @company_admin, true)
    input = InputTO.new(@regular_user.form_input_id(:send_email), false)
    to.add_input(input)
    to.test(self)
  end

  test "the company selector is visible for app admin edit modal" do
    to = EditTO.new(@app_admin, @company_admin, true)
    input = SelectTO.new(@app_admin.form_input_id(:company_id))
    to.add_input(input)
    to.test(self)
  end

  test "user is warned about a deleted/not found record for edit modal" do
    to = EditTO.new(@company_admin, @regular_user, nil)
    to.test_nf(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for updating a record

  # test who can and can't update email addresses

  emu = { email: "updated@updated.com" }

  test "a logged out user can't update email" do
    to = UpdateTO.new(nil, @regular_user, emu, false)
    to.update_fields = @email
    to.test(self)
  end

  test "regular user can update email for self" do
    to = UpdateTO.new(@regular_user, @regular_user, emu, true)
    to.update_fields = @email
    to.test(self)
  end

  test "company admin can update email for self" do
    to = UpdateTO.new(@company_admin, @company_admin, emu, true)
    to.update_fields = @email
    to.test(self)
  end

  test "app admin can update email for self" do
    to = UpdateTO.new(@app_admin, @app_admin, emu, true)
    to.update_fields = @email
    to.test(self)
  end

  test "regular user can't update email for user" do
    to = UpdateTO.new(@regular_user, @company_admin, emu, false)
    to.update_fields = @email
    to.test(self)
  end

  test "company admin can update email for user in company" do
    to = UpdateTO.new(@company_admin, @regular_user, emu, true)
    to.update_fields = @email
    to.test(self)
  end

  test "company admin can't update email for user in other company" do
    to = UpdateTO.new(@company_admin, @other_user, emu, false)
    to.update_fields = @email
    to.test(self)
  end

  test "app admin can update email for user in other company" do
    to = UpdateTO.new(@app_admin, @other_user, emu, true)
    to.update_fields = @email
    to.test(self)
  end

  # test who can and can't update passwords

  test "logged out user should not be able to update password" do
    to = UpdateTO.new(nil, @regular_user, @pu, false)
    to.update_fields = @password
    to.test(self)
  end

  test "regular user can update password for self" do
    to = UpdateTO.new(@regular_user, @regular_user, @pu, true)
    to.update_fields = @password
    to.test(self)
  end

  test "company admin can update password for self" do
    to = UpdateTO.new(@company_admin, @company_admin, @pu, true)
    to.update_fields = @password
    to.test(self)
  end

  test "app admin can update password for self" do
    to = UpdateTO.new(@app_admin, @app_admin, @pu, true)
    to.update_fields = @password
    to.test(self)
  end

  test "regular user can't update password for user" do
    to = UpdateTO.new(@regular_user, @company_admin, @pu, false)
    to.update_fields = @password
    to.test(self)
  end

  test "company admin can update password for user in same company" do
    to = UpdateTO.new(@company_admin, @regular_user, @pu, true)
    to.update_fields = @password
    to.test(self)
  end

  test "app admin can update password for user in same company" do
    to = UpdateTO.new(@app_admin, @regular_user, @pu, true)
    to.update_fields = @password
    to.test(self)
  end

  test "company admin can't update password for user in other company" do
    to = UpdateTO.new(@company_admin, @other_user, @pu, false)
    to.update_fields = @password
    to.test(self)
  end

  test "app admin can update password for user in other company" do
    to = UpdateTO.new(@app_admin, @other_user, @pu, true)
    to.update_fields = @password
    to.test(self)
  end

  test "sending password reset email fails without email address" do
    to = UpdateTO.new(@company_admin, @regular_user, @pu, false)
    to.update_fields = @password
    to.params_hash[:send_email] = 1
    to.params_hash[:email] = ""
    to.add_error_to(ErrorTO.new("form.errors.email.blank", :email))
    to.add_error_to(ErrorTO.new("form.errors.email.send.email_blank", :send_email))
    to.test(self)
  end

  test "sending password reset email fails if password does not change" do
    to = UpdateTO.new(@company_admin, @regular_user, @pu, false)
    to.update_fields = @password
    to.params_hash[:send_email] = 1
    to.params_hash[:password] = ""
    to.add_error_to(ErrorTO.new("form.errors.email.password.no_change", :password))
    to.add_error_to(ErrorTO.new("form.errors.email.send.password_no_change", :send_email))
    to.test(self)
  end

  # test who can and can't update username, first_name, and last_name.

  nu = { username: "updated", first_name: "updated", last_name: "updated" }

  test "logged out user can't update names" do
    to = UpdateTO.new(nil, @regular_user, nu, false)
    to.update_fields = @names
    to.test(self)
  end

  test "regular user can't update names for self" do
    to = UpdateTO.new(@regular_user, @regular_user, nu, false)
    to.update_fields = @names
    to.test(self)
  end

  test "regular user can't update names for user" do
    to = UpdateTO.new(@regular_user, @company_admin, nu, false)
    to.update_fields = @names
    to.test(self)
  end

  test "company admin can update names for self" do
    to = UpdateTO.new(@company_admin, @company_admin, nu, true)
    to.update_fields = @names
    to.test(self)
  end

  test "company admin can update names for user in same company" do
    to = UpdateTO.new(@company_admin, @regular_user, nu, true)
    to.update_fields = @names
    to.test(self)
  end

  test "company admin can't update names for user in other company" do
    to = UpdateTO.new(@company_admin, @other_user, nu, false)
    to.update_fields = @names
    to.test(self)
  end

  test "app admin can update names for self" do
    to = UpdateTO.new(@app_admin, @app_admin, nu, true)
    to.update_fields = @names
    to.test(self)
  end

  test "app admin can update names for user in same company" do
    to = UpdateTO.new(@app_admin, @regular_user, nu, true)
    to.update_fields = @names
    to.test(self)
  end

  test "app admin can update names for user in other company" do
    to = UpdateTO.new(@app_admin, @other_user, nu, true)
    to.update_fields = @names
    to.test(self)
  end

  # test who can and can't update enabled and company admin booleans

  disadm1 = { enabled: false, company_admin: true }
  disadm0 = { enabled: false, company_admin: false }

  test "a logged out user can't update enabled/admin" do
    to = UpdateTO.new(nil, @regular_user, disadm1, false)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "regular user can't update enabled/admin for self" do
    to = UpdateTO.new(@regular_user, @regular_user, disadm1, false)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "regular user can't update enabled/admin for user" do
    to = UpdateTO.new(@regular_user, @company_admin, disadm0, false)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "company admin can update enabled/admin for user" do
    to = UpdateTO.new(@company_admin, @regular_user, disadm1, true)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "company admin can't update enabled/admin for self" do
    to = UpdateTO.new(@company_admin, @company_admin, disadm0, false)
    to.update_fields = @enabled_admin
    to.add_error_to(ErrorTO.new(:disabled_self, :enabled))
    to.add_error_to(ErrorTO.new(:disabled_self, :company_admin))
    to.test(self)
  end

  test "company admin can't update enabled/admin for other user" do
    to = UpdateTO.new(@company_admin, @other_user, disadm1, false)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "app admin can update enabled/admin for user" do
    to = UpdateTO.new(@app_admin, @regular_user, disadm1, true)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "app admin can't update enabled/admin for self" do
    to = UpdateTO.new(@app_admin, @app_admin, disadm0, false)
    to.update_fields = @enabled_admin
    to.add_error_to(ErrorTO.new(:disabled_self, :enabled))
    to.add_error_to(ErrorTO.new(:disabled_self, :company_admin))
    to.test(self)
  end

  test "app admin can update enabled/admin for other user" do
    to = UpdateTO.new(@app_admin, @other_user, disadm1, true)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "user is warned about a deleted/not found record for update" do
    to = UpdateTO.new(@company_admin, @regular_user, disadm1, nil)
    to.test_nf(self)
  end

  # test for app_admin should not be updated through the web.

  appadm = { app_admin: true }

  test "logged out user can't update app admin" do
    to = UpdateTO.new(nil, @regular_user, appadm, false)
    to.update_fields = [:app_admin]
    to.test(self)
  end

  test "regular user can't update app admin" do
    to = UpdateTO.new(@regular_user, @regular_user, appadm, false)
    to.update_fields = [:app_admin]
    to.test(self)
  end

  test "company admin can't update app admin" do
    to = UpdateTO.new(@company_admin, @company_admin, appadm, false)
    to.update_fields = [:app_admin]
    to.test(self)
  end

  test "app admin can't update app admin" do
    to = UpdateTO.new(@app_admin, @company_admin, appadm, false)
    to.update_fields = [:app_admin]
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for index records

  test "a logged out user can't index" do
    IndexTo.new(nil, @new, false).test(self)
  end

  test "a regular user can't index" do
    IndexTo.new(@regular_user, @new, false).test(self)
  end

  test "company admin can index and see users except self" do
    to = IndexTo.new(@company_admin, @new, true)
    to.add_visible_y_record(@regular_user)
    to.add_visible_y_record(@app_admin)
    to.add_visible_n_record(@other_admin)
    to.add_visible_n_record(@other_user)
    to.add_visible_n_record(@delete_me_user)
    to.add_visible_n_record(@company_admin)
    to.test(self)
  end

  test "app admin can index and see all records except self" do
    to = IndexTo.new(@app_admin, @new, true)
    to.add_visible_y_record(@regular_user)
    to.add_visible_y_record(@company_admin)
    to.add_visible_y_record(@other_admin)
    to.add_visible_y_record(@other_user)
    to.add_visible_y_record(@delete_me_user)
    to.add_visible_n_record(@app_admin)
    to.test(self)
  end

  test "page title should be there" do
    to = IndexTo.new(@company_admin, @new, true)
    to.test_title = true
    to.test(self)
  end

  test "page should have new record button" do
    to = IndexTo.new(@company_admin, @new, true)
    to.test_new = true
    to.test(self)
  end

  test "should see the edit buttons" do
    to = IndexTo.new(@company_admin, @new, true)
    to.test_edit = true
    to.add_visible_edit_record(@regular_user)
    to.add_visible_edit_record(@app_admin)
    to.test(self)
  end

  test "page should have enabled filter" do
    to = IndexTo.new(@company_admin, @new, true)
    to.test_enabled_filter = true
    to.test(self)
  end

  test "should see both enabled and disabled with all filter." do
    to = IndexTo.new(@company_admin, @new, true)
    @regular_user.update_column(:enabled, false)
    to.add_visible_y_record(@regular_user)
    to.add_visible_y_record(@app_admin)
    to.test(self)
  end

  test "should only see enabled with enabled filter." do
    to = IndexTo.new(@company_admin, @new, true)
    to.query = :enabled
    to.add_visible_y_record(@app_admin)
    @regular_user.update_column(:enabled, false)
    to.add_visible_n_record(@regular_user)
    to.test(self)
  end

  test "should only see disabled with disabled filter." do
    to = IndexTo.new(@company_admin, @new, true)
    to.query = :disabled
    to.add_visible_n_record(@app_admin)
    @regular_user.update_column(:enabled, false)
    to.add_visible_y_record(@regular_user)
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # tests for reset password functionality

  test "user changing password for self doesn't trigger reset password" do
    to = UpdateTO.new(@regular_user, @regular_user, @pu, false)
    to.update_fields = [:password_reset]
    to.test(self)
  end

  test "admin changing password for user does trigger reset password" do
    to = UpdateTO.new(@company_admin, @regular_user, @pu, true)
    to.update_fields = [:password_reset]
    to.test(self)
  end

  test "Monster test that checks the full flow of a user's password being reset and that user resetting it." do
    to = UpdateTO.new(@app_admin, @company_admin, @pu, true)
    to.update_fields = [:password_reset]
    to.test(self)
    log_in_as(@company_admin, @pu[:password])
    # There's 2 redirects because by default logged in redirects to root,
    # then when password_reset is true,
    # you get redirected to the update password page.
    follow_redirect!
    assert_redirected_to new_auth_password_reset_path
    follow_redirect!
    # Should be 2 links, one being the Mulder WMS logo top left, the other being the log out link.
    assert_select 'a[href]', 2
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', root_path
    assert_select "form"
    assert_select "form input[id=auth_password_reset_password]"
    assert_select "form input[id=auth_password_reset_password_confirmation]"
    assert_select "form input[type=submit][value='#{I18n.t("auth/users.title.update_password")}']"
    # trying to load other TMS pages should redirect the user back to update password.
    get root_path
    assert_redirected_to new_auth_password_reset_path
    get auth_users_path
    assert_redirected_to new_auth_password_reset_path
    get edit_auth_user_path(@company_admin)
    assert_redirected_to new_auth_password_reset_path
    # user should not be able to use the same password they
    # logged in with as their new updated password.
    @new_pr = Auth::PasswordResetForm.new(@company_admin)
    to = CreateTO.new(@company_admin, @new_pr, @pu, false)
    to.xhr = false
    to.path = auth_password_resets_path
    to.add_error_to ErrorTO.new(:same, :password)
    to.check_count = false
    to.test(self)
    assert_template 'auth/password_resets/new'
    # user should be able to update their password with a new password
    to.params_hash = @pu2
    to.validity = true
    to.test(self)
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'div.alert-success', I18n.t("alert.save.password_success")
    # password_reset should be false after update.
    @company_admin.reload
    assert_equal false, @company_admin.password_reset
  end

end
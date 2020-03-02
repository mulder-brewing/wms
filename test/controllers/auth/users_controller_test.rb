require 'test_helper'

class Auth::UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = auth_users(:regular_user)
    @company_admin = auth_users(:company_admin_user)
    @app_admin = auth_users(:app_admin_user)
    @other_admin = auth_users(:other_company_admin)
    @other_user = auth_users(:other_company_user)
    @delete_me_user = auth_users(:delete_me_user)

    @new = Auth::User.new
    @form = Auth::UserForm

    @averagejoe_access_policy = access_policies(:average_joe_access_policy_everything)
    @other_access_policy = access_policies(:other_access_policy_everything)

    @ph = { first_name: "Test", last_name: "User", username: "new_user",
      password: "Password1$", password_confirmation: "Password1$",
      company_admin: false, app_admin: false,
      access_policy_id: @averagejoe_access_policy.id }
    @pu = { password: "NewPassword123$",
      password_confirmation: "NewPassword123$" }
    @emu = { email: "updated@updated.com" }
    @nu = { username: "updated", first_name: "updated", last_name: "updated" }
    @appadm = { app_admin: true }
    @disadm1 = { enabled: false, company_admin: true }
    @disadm0 = { enabled: false, company_admin: false }

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
    to.visibles << FormFieldVisible.new(form: @form, field: :company_id, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :first_name)
    to.visibles << FormFieldVisible.new(form: @form, field: :last_name)
    to.visibles << FormFieldVisible.new(form: @form, field: :email)
    to.visibles << FormFieldVisible.new(form: @form, field: :username)
    to.visibles << FormFieldVisible.new(form: @form, field: :password)
    to.visibles << FormFieldVisible.new(form: @form, field: :password_confirmation)
    to.visibles << FormFieldVisible.new(form: @form, field: :send_email)
    to.visibles << FormFieldVisible.new(form: @form, field: :access_policy_id)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_admin)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled, visible: false)
    to.test(self)
  end

  test "access policy selector has enabled policies for company admin" do
    to = NewTO.new(@company_admin, @new, true)
    count = AccessPolicy.enabled_where_company(@company_admin.company_id).count
    to.visibles << FormSelectOptionVisible.new(form: @form,
      field: :access_policy_id, count: count, blank_option: true)
    to.test(self)
  end

  test "access policy selector doesn't have disabled policies" do
    to = NewTO.new(@company_admin, @new, true)
    @averagejoe_access_policy.update_column(:enabled, false)
    text = @averagejoe_access_policy.description
    id = @averagejoe_access_policy.id
    to.visibles << FormSelectOptionVisible.new(form: @form,
      field: :access_policy_id, text: text, option_id: id, visible: false)
    to.test(self)
  end

  test "a app admin can get new modal" do
    NewTO.new(@app_admin, @new, true).test(self)
  end

  test "app admin field visibility new modal" do
    to = NewTO.new(@app_admin, @new, true)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_id)
    to.visibles << FormFieldVisible.new(form: @form, field: :first_name)
    to.visibles << FormFieldVisible.new(form: @form, field: :last_name)
    to.visibles << FormFieldVisible.new(form: @form, field: :email)
    to.visibles << FormFieldVisible.new(form: @form, field: :username)
    to.visibles << FormFieldVisible.new(form: @form, field: :password)
    to.visibles << FormFieldVisible.new(form: @form, field: :password_confirmation)
    to.visibles << FormFieldVisible.new(form: @form, field: :send_email)
    to.visibles << FormFieldVisible.new(form: @form, field: :access_policy_id)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_admin)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled, visible: false)
    to.test(self)
  end

  test "access policy selector is empty for app admin" do
    to = NewTO.new(@app_admin, @new, true)
    to.visibles << FormSelectOptionVisible.new(form: @form,
      field: :access_policy_id, count: 0, blank_option: true)
    to.test(self)
  end

  test "new modal title" do
    to = NewTO.new(@company_admin, @new, true)
    to.visibles << NewModalTitleVisible.new(model_class: Auth::User)
    to.test(self)
  end

  test "new modal buttons" do
    to = NewTO.new(@company_admin, @new, true)
    to.visibles << ModalFooterVisible.new(class: Button::ModalSaveButton.class_name)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
    to.test(self)
  end

  test "new modal timestamps aren't visible" do
    to = NewTO.new(@company_admin, @new, true)
    to.visibles << ModalTimestampsVisible.new(visible: false)
    to.test(self)
  end

  test "new modal doesn't show reset password button" do
    to = NewTO.new(@company_admin, @new, true)
    to.visibles << ModalBodyVisible.new(class: Button::ResetPasswordButton.class_name, visible: false)
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for creating a record.

  test "a logged out user can't create" do
    CreateTO.new(nil, @new, false, params_hash: @ph).test(self)
  end

  test "a regular user can't create" do
    CreateTO.new(@regular_user, @new, false, params_hash: @ph).test(self)
  end

  test "a company admin can create" do
    CreateTO.new(@company_admin, @new, true, params_hash: @ph).test(self)
  end

  test "a app admin can create" do
    to = CreateTO.new(@app_admin, @new, true, params_hash: @ph)
    to.test(self)
  end

  test "company admin can only create own company user" do
    to = CreateTO.new(@company_admin, @new, true, params_hash: @ph)
    to.merge_params_hash({ company_id: @other_admin.company_id })
    to.attributes = { :company_id => @company_admin.company_id }
    to.test(self)
  end

  test "app admin can create user in any company" do
    to = CreateTO.new(@app_admin, @new, true, params_hash: @ph)
    to.merge_params_hash({ company_id: @other_admin.company_id })
    to.params_hash[:access_policy_id] = @other_access_policy.id
    to.attributes = { :company_id => @other_admin.company_id }
    to.test(self)
  end

  test "access policy select should have options for record's company" do
    to = CreateTO.new(@app_admin, @new, false, params_hash: @ph)
    to.merge_params_hash({ company_id: @other_admin.company_id })
    # Setting this to nil so create fails.
    to.params_hash[:access_policy_id] = nil
    # First, check the count of the options.
    count = AccessPolicy.enabled_where_company(@other_access_policy.company_id).count
    to.visibles << FormSelectOptionVisible.new(form: @form,
      field: :access_policy_id, count: count, blank_option: true)
    # Next, verify the correct option is there.
    text = @other_access_policy.description
    id = @other_access_policy.id
    to.visibles << FormSelectOptionVisible.new(form: @form,
      field: :access_policy_id, text: text, option_id: id)
    to.test(self)
  end

  test "app admin can't create user with mismatch access policy" do
    to = CreateTO.new(@app_admin, @new, false, params_hash: @ph)
    to.merge_params_hash({ company_id: @other_admin.company_id })
    to.visibles << FormBaseErrorVisible.new(field: :access_policy, type: :does_not_belong)
    to.test(self)
  end

  test "record should be enabled by default when it's created" do
    to = CreateTO.new(@company_admin, @new, true, params_hash: @ph)
    to.attributes = { :enabled => true }
    to.test(self)
  end

  test "username should be unique across all companies" do
    CreateTO.new(@company_admin, @new, true, params_hash: @ph).test(self)
    to = CreateTO.new(@other_admin, @new, false, params_hash: @ph)
    to.visibles << FormFieldErrorVisible.new(field: :username, type: :unique)
    to.test(self)
  end

  test "password_reset flag is true when user created" do
    to = CreateTO.new(@company_admin, @new, true, params_hash: @ph)
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
    to.visibles << EditModalTitleVisible.new(model_class: Auth::User)
    to.test(self)
  end

  test "edit modal save and close buttons" do
    to = EditTO.new(@regular_user, @regular_user, true)
    to.visibles << ModalFooterVisible.new(class: Button::ModalSaveButton.class_name)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
    to.test(self)
  end

  test "edit modal does show reset password button" do
    to = EditTO.new(@regular_user, @regular_user, true)
    to.visibles << ModalBodyVisible.new(class: Button::ResetPasswordButton.class_name)
    to.test(self)
  end

  test "edit modal timestamps are visible" do
    to = EditTO.new(@regular_user, @regular_user, true)
    to.visibles << ModalTimestampsVisible.new
    to.test(self)
  end

  test "company admin field visibility" do
    to = EditTO.new(@company_admin, @regular_user, true)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_id, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :first_name)
    to.visibles << FormFieldVisible.new(form: @form, field: :last_name)
    to.visibles << FormFieldVisible.new(form: @form, field: :email)
    to.visibles << FormFieldVisible.new(form: @form, field: :username)
    to.visibles << FormFieldVisible.new(form: @form, field: :password, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :password_confirmation, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :send_email, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :access_policy_id)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_admin)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled)
    to.test(self)
  end

  test "regular user field visibility" do
    to = EditTO.new(@regular_user, @regular_user, true)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_id, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :first_name, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :last_name, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :email)
    to.visibles << FormFieldVisible.new(form: @form, field: :username, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :password, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :password_confirmation, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :send_email, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :access_policy_id, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_admin, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled, visible: false)
    to.test(self)
  end

  test "the enable/disable switch isn't visible when editing self" do
    to = EditTO.new(@company_admin, @company_admin, true)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled, visible: false)
    to.test(self)
  end

  test "the admin checkbox isn't visible when editing self" do
    to = EditTO.new(@company_admin, @company_admin, true)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_admin, visible: false)
    to.test(self)
  end

  test "the company selector is visible for app admin edit modal" do
    to = EditTO.new(@app_admin, @company_admin, true)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_id)
    to.test(self)
  end

  test "user is warned about a deleted/not found record for edit modal" do
    to = EditTO.new(@company_admin, @regular_user, nil)
    to.test_nf(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for updating a record

  # test who can and can't update email addresses

  test "a logged out user can't update email" do
    to = UpdateTO.new(nil, @regular_user, false, params_hash: @emu)
    to.update_fields = @email
    to.test(self)
  end

  test "regular user can update email for self" do
    to = UpdateTO.new(@regular_user, @regular_user, true, params_hash: @emu)
    to.update_fields = @email
    to.test(self)
  end

  test "company admin can update email for self" do
    to = UpdateTO.new(@company_admin, @company_admin, true, params_hash: @emu)
    to.update_fields = @email
    to.test(self)
  end

  test "app admin can update email for self" do
    to = UpdateTO.new(@app_admin, @app_admin, true, params_hash: @emu)
    to.update_fields = @email
    to.test(self)
  end

  test "regular user can't update email for user" do
    to = UpdateTO.new(@regular_user, @company_admin, false, params_hash: @emu)
    to.update_fields = @email
    to.test(self)
  end

  test "company admin can update email for user in company" do
    to = UpdateTO.new(@company_admin, @regular_user, true, params_hash: @emu)
    to.update_fields = @email
    to.test(self)
  end

  test "company admin can't update email for user in other company" do
    to = UpdateTO.new(@company_admin, @other_user, false, params_hash: @emu)
    to.update_fields = @email
    to.test(self)
  end

  test "app admin can update email for user in other company" do
    to = UpdateTO.new(@app_admin, @other_user, true, params_hash: @emu)
    to.update_fields = @email
    to.test(self)
  end

  # Nobody should be able to update passwords.  There is a separate
  # controller for updating a user's password.

  test "logged out user should not be able to update password" do
    to = UpdateTO.new(nil, @regular_user, false, params_hash: @pu)
    to.update_fields = @password
    to.test(self)
  end

  test "regular user can't update password for self" do
    to = UpdateTO.new(@regular_user, @regular_user, false, params_hash: @pu)
    to.update_fields = @password
    to.test(self)
  end

  test "company admin can't update password for self" do
    to = UpdateTO.new(@company_admin, @company_admin, false, params_hash: @pu)
    to.update_fields = @password
    to.test(self)
  end

  test "app admin can't update password for self" do
    to = UpdateTO.new(@app_admin, @app_admin, false, params_hash: @pu)
    to.update_fields = @password
    to.test(self)
  end

  test "regular user can't update password for user" do
    to = UpdateTO.new(@regular_user, @company_admin, false, params_hash: @pu)
    to.update_fields = @password
    to.test(self)
  end

  test "company admin can't update password for user in same company" do
    to = UpdateTO.new(@company_admin, @regular_user, false, params_hash: @pu)
    to.update_fields = @password
    to.test(self)
  end

  test "app admin can't update password for user in same company" do
    to = UpdateTO.new(@app_admin, @regular_user, false, params_hash: @pu)
    to.update_fields = @password
    to.test(self)
  end

  test "company admin can't update password for user in other company" do
    to = UpdateTO.new(@company_admin, @other_user, false, params_hash: @pu)
    to.update_fields = @password
    to.test(self)
  end

  test "app admin can't update password for user in other company" do
    to = UpdateTO.new(@app_admin, @other_user, false, params_hash: @pu)
    to.update_fields = @password
    to.test(self)
  end

  # test who can and can't update username, first_name, and last_name.

  test "logged out user can't update names" do
    to = UpdateTO.new(nil, @regular_user, false, params_hash: @nu)
    to.update_fields = @names
    to.test(self)
  end

  test "regular user can't update names for self" do
    to = UpdateTO.new(@regular_user, @regular_user, false, params_hash: @nu)
    to.update_fields = @names
    to.test(self)
  end

  test "regular user can't update names for user" do
    to = UpdateTO.new(@regular_user, @company_admin, false, params_hash: @nu)
    to.update_fields = @names
    to.test(self)
  end

  test "company admin can update names for self" do
    to = UpdateTO.new(@company_admin, @company_admin, true, params_hash: @nu)
    to.update_fields = @names
    to.test(self)
  end

  test "company admin can update names for user in same company" do
    to = UpdateTO.new(@company_admin, @regular_user, true, params_hash: @nu)
    to.update_fields = @names
    to.test(self)
  end

  test "company admin can't update names for user in other company" do
    to = UpdateTO.new(@company_admin, @other_user, false, params_hash: @nu)
    to.update_fields = @names
    to.test(self)
  end

  test "app admin can update names for self" do
    to = UpdateTO.new(@app_admin, @app_admin, true, params_hash: @nu)
    to.update_fields = @names
    to.test(self)
  end

  test "app admin can update names for user in same company" do
    to = UpdateTO.new(@app_admin, @regular_user, true, params_hash: @nu)
    to.update_fields = @names
    to.test(self)
  end

  test "app admin can update names for user in other company" do
    to = UpdateTO.new(@app_admin, @other_user, true, params_hash: @nu)
    to.update_fields = @names
    to.test(self)
  end

  # test who can and can't update enabled and company admin booleans

  test "a logged out user can't update enabled/admin" do
    to = UpdateTO.new(nil, @regular_user, false, params_hash: @disadm1)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "regular user can't update enabled/admin for self" do
    to = UpdateTO.new(@regular_user, @regular_user, false, params_hash: @disadm1)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "regular user can't update enabled/admin for user" do
    to = UpdateTO.new(@regular_user, @company_admin, false, params_hash: @disadm0)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "company admin can update enabled/admin for user" do
    to = UpdateTO.new(@company_admin, @regular_user, true, params_hash: @disadm1)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "company admin can't update enabled/admin for self" do
    to = UpdateTO.new(@company_admin, @company_admin, false, params_hash: @disadm0)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "company admin can't update enabled/admin for other user" do
    to = UpdateTO.new(@company_admin, @other_user, false, params_hash: @disadm1)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "app admin can update enabled/admin for user" do
    to = UpdateTO.new(@app_admin, @regular_user, true, params_hash: @disadm1)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "app admin can't update enabled/admin for self" do
    to = UpdateTO.new(@app_admin, @app_admin, false, params_hash: @disadm0)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "app admin can update enabled/admin for other user" do
    to = UpdateTO.new(@app_admin, @other_user, true, params_hash: @disadm1)
    to.update_fields = @enabled_admin
    to.test(self)
  end

  test "user is warned about a deleted/not found record for update" do
    to = UpdateTO.new(@company_admin, @regular_user, nil, params_hash: @disadm1)
    to.test_nf(self)
  end

  # test for app_admin should not be updated through the web.

  test "logged out user can't update app admin" do
    to = UpdateTO.new(nil, @regular_user, false, params_hash: @appadm)
    to.update_fields = [:app_admin]
    to.test(self)
  end

  test "regular user can't update app admin" do
    to = UpdateTO.new(@regular_user, @regular_user, false, params_hash: @appadm)
    to.update_fields = [:app_admin]
    to.test(self)
  end

  test "company admin can't update app admin" do
    to = UpdateTO.new(@company_admin, @company_admin, false, params_hash: @appadm)
    to.update_fields = [:app_admin]
    to.test(self)
  end

  test "app admin can't update app admin" do
    to = UpdateTO.new(@app_admin, @company_admin, false, params_hash: @appadm)
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
    to.visibles << IndexTRecordVisible.new(record: @regular_user)
    to.visibles << IndexTRecordVisible.new(record: @app_admin)
    to.visibles << IndexTRecordVisible.new(record: @other_admin, visible: false)
    to.visibles << IndexTRecordVisible.new(record: @other_user, visible: false)
    to.visibles << IndexTRecordVisible.new(record: @delete_me_user, visible: false)
    to.visibles << IndexTRecordVisible.new(record: @company_admin, visible: false)
    to.test(self)
  end

  test "app admin can index and see all records except self" do
    to = IndexTo.new(@app_admin, @new, true)
    to.visibles << IndexTRecordVisible.new(record: @regular_user)
    to.visibles << IndexTRecordVisible.new(record: @app_admin, visible: false)
    to.visibles << IndexTRecordVisible.new(record: @other_admin)
    to.visibles << IndexTRecordVisible.new(record: @other_user)
    to.visibles << IndexTRecordVisible.new(record: @delete_me_user)
    to.visibles << IndexTRecordVisible.new(record: @company_admin)
    to.test(self)
  end

  test "page title should be there" do
    to = IndexTo.new(@company_admin, @new, true)
    to.visibles << IndexRecordsTitleVisible.new(model_class: Auth::User)
    to.test(self)
  end

  test "page should have new record button" do
    to = IndexTo.new(@company_admin, @new, true)
    to.visibles << HeaderVisible.new(class: Button::NewButton.class_name)
    to.test(self)
  end

  test "should see the edit buttons" do
    to = IndexTo.new(@company_admin, @new, true)
    to.visibles << IndexTBodyVisible.new(class: Button::IndexEditButton.class_name)
    to.test(self)
  end

  test "company admin should not see the become button" do
    to = IndexTo.new(@company_admin, @new, true)
    to.visibles << IndexTBodyVisible.new(class: Button::BecomeButton.class_name,
      visible: false)
    to.test(self)
  end

  test "app admin should see the become button" do
    to = IndexTo.new(@app_admin, @new, true)
    to.visibles << IndexTBodyVisible.new(class: Button::BecomeButton.class_name)
    to.test(self)
  end

  test "company admin should not see the company column" do
    to = IndexTo.new(@company_admin, @new, true)
    to.visibles << IndexTHeadVisible.new(
      id: Table::Auth::UsersIndexTable::COMPANY_COLUMN_TEST_ID, visible: false)
    to.test(self)
  end

  test "app admin should see the company column" do
    to = IndexTo.new(@app_admin, @new, true)
    to.visibles << IndexTHeadVisible.new(
      id: Table::Auth::UsersIndexTable::COMPANY_COLUMN_TEST_ID)
    to.test(self)
  end

  test "page should have enabled filter" do
    to = IndexTo.new(@company_admin, @new, true)
    to.visibles << EnabledFilterVisible.new
    to.test(self)
  end

  test "should see both enabled and disabled with all filter." do
    to = IndexTo.new(@company_admin, @new, true)
    @regular_user.update_column(:enabled, false)
    to.visibles << IndexTRecordVisible.new(record: @regular_user)
    to.visibles << IndexTRecordVisible.new(record: @app_admin)
    to.test(self)
  end

  test "should only see enabled with enabled filter." do
    to = IndexTo.new(@company_admin, @new, true)
    to.query = :enabled
    to.visibles << IndexTRecordVisible.new(record: @app_admin)
    @regular_user.update_column(:enabled, false)
    to.visibles << IndexTRecordVisible.new(record: @regular_user, visible: false)
    to.test(self)
  end

  test "should only see disabled with disabled filter." do
    to = IndexTo.new(@company_admin, @new, true)
    to.query = :disabled
    to.visibles << IndexTRecordVisible.new(record: @app_admin, visible: false)
    @regular_user.update_column(:enabled, false)
    to.visibles << IndexTRecordVisible.new(record: @regular_user)
    to.test(self)
  end

end

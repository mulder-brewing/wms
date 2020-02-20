require 'test_helper'

class Auth::PasswordUpdatesControllerTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear

    @regular_user = auth_users(:regular_user)
    @company_admin = auth_users(:company_admin_user)
    @other_user = auth_users(:other_company_user)

    @new = Auth::User.new
    @form = Auth::PasswordUpdateForm

    @pu = { password: "NewPassword123$",
      password_confirmation: "NewPassword123$" }

    @password = [:password_digest]
  end

  # ----------------------------------------------------------------------------
  # Tests for edit modal

  test "regular user can get modal for self" do
    to = EditTO.new(@regular_user, @regular_user, true)
    to.path = edit_auth_password_update_path(@regular_user)
    to.test(self)
  end

  test "regular user only sees password and password confirmation" do
    to = EditTO.new(@regular_user, @regular_user, true)
    to.path = edit_auth_password_update_path(@regular_user)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_id, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :first_name, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :last_name, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :username, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :access_policy_id, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_admin, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :email, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :password)
    to.visibles << FormFieldVisible.new(form: @form, field: :password_confirmation)
    to.visibles << FormFieldVisible.new(form: @form, field: :send_email, visible: false)
    to.test(self)
  end

  test "regular user can't get modal for user in company" do
    to = EditTO.new(@regular_user, @company_admin, false)
    to.path = edit_auth_password_update_path(@company_admin)
    to.test(self)
  end

  test "company admin can get modal for user in company" do
    to = EditTO.new(@company_admin, @regular_user, true)
    to.path = edit_auth_password_update_path(@regular_user)
    to.test(self)
  end

  test "company admin can't get modal for user in other company" do
    to = EditTO.new(@company_admin, @other_user, false)
    to.path = edit_auth_password_update_path(@other_user)
    to.test(self)
  end

  test "company admin doesn't see these things for user in company" do
    to = EditTO.new(@company_admin, @regular_user, true)
    to.path = edit_auth_password_update_path(@regular_user)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_id, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :first_name, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :last_name, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :username, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :access_policy_id, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :company_admin, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :enabled, visible: false)
    to.test(self)
  end

  test "company admin sees these things for user in company" do
    to = EditTO.new(@company_admin, @regular_user, true)
    to.path = edit_auth_password_update_path(@regular_user)
    to.visibles << FormFieldVisible.new(form: @form, field: :email)
    to.visibles << FormFieldVisible.new(form: @form, field: :password)
    to.visibles << FormFieldVisible.new(form: @form, field: :password_confirmation)
    to.visibles << FormFieldVisible.new(form: @form, field: :send_email)
    to.test(self)
  end

  test "company admin doesn't see email and send email for self" do
    to = EditTO.new(@company_admin, @company_admin, true)
    to.path = edit_auth_password_update_path(@company_admin)
    to.visibles << FormFieldVisible.new(form: @form, field: :email, visible: false)
    to.visibles << FormFieldVisible.new(form: @form, field: :send_email, visible: false)
    to.test(self)
  end

  test "timestamps aren't visible" do
    to = EditTO.new(@company_admin, @regular_user, true)
    to.path = edit_auth_password_update_path(@regular_user)
    to.visibles << ModalTimestampsVisible.new(visible: false)
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for updating password

  test "regular user can update password for self without being flagged for password reset" do
    to = UpdateTO.new(@regular_user, @regular_user, @pu, true)
    to.path = auth_password_update_path(@regular_user)
    to.params_key = :auth_password_update
    to.update_fields = @password
    to.attributes = { :password_reset => false }
    to.test(self)
  end

  test "regular user can't update password for user in company" do
    to = UpdateTO.new(@regular_user, @company_admin, @pu, false)
    to.path = auth_password_update_path(@company_admin)
    to.params_key = :auth_password_update
    to.update_fields = @password
    to.test(self)
  end

  test "company admin can update password for user in company, " +
      "and user is flagged for password resest, " do
    to = UpdateTO.new(@company_admin, @regular_user, @pu, true)
    to.path = auth_password_update_path(@regular_user)
    to.params_key = :auth_password_update
    to.update_fields = @password
    to.attributes = { :password_reset => true }
    to.test(self)
  end

  test "company admin can't update password for user in other company" do
    to = UpdateTO.new(@company_admin, @other_user, @pu, false)
    to.path = auth_password_update_path(@other_user)
    to.params_key = :auth_password_update
    to.update_fields = @password
    to.test(self)
  end

end

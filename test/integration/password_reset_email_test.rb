require 'test_helper'

class PasswordResetEmailTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear

    @regular_user = auth_users(:regular_user)
    @company_admin = auth_users(:company_admin_user)
    @other_user = auth_users(:other_company_user)

    @new = Auth::User.new

    @pu = { password: "NewPassword123$",
      password_confirmation: "NewPassword123$" }

    @password = [:password_digest]
  end

  test "email sends if email is valid and send email is true" do
    to = UpdateTO.new(@company_admin, @regular_user, true, params_hash: @pu)
    to.merge_params_hash({ email: "a@e.c", send_email: true })
    to.path = auth_password_update_path(@regular_user)
    to.params_key = :auth_password_update
    to.update_fields = @password
    to.test(self)
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test "email doesn't send if send email is false" do
    to = UpdateTO.new(@company_admin, @regular_user, true, params_hash: @pu)
    to.merge_params_hash({ email: "a@e.c", send_email: false })
    to.path = auth_password_update_path(@regular_user)
    to.params_key = :auth_password_update
    to.update_fields = @password
    to.test(self)
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "email doesn't send if email is blank" do
    to = UpdateTO.new(@company_admin, @regular_user, false, params_hash: @pu)
    to.merge_params_hash({ email: "", send_email: true })
    to.path = auth_password_update_path(@regular_user)
    to.params_key = :auth_password_update
    to.update_fields = @password
    to.visibles << FormFieldErrorVisible.new(field: :send_email,
      error: "errors.attributes.send_email.blank_email")
    to.visibles << FormFieldErrorVisible.new(field: :email,
      error: "errors.attributes.email.blank_send")
    to.test(self)
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "email doesn't send with invalid email address" do
    to = UpdateTO.new(@company_admin, @regular_user, false, params_hash: @pu)
    to.merge_params_hash({ email: "invalid", send_email: true })
    to.path = auth_password_update_path(@regular_user)
    to.params_key = :auth_password_update
    to.update_fields = @password
    to.visibles << FormFieldErrorVisible.new(field: :email, type: :invalid)
    to.test(self)
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

end

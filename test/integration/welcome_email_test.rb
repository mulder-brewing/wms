require 'test_helper'
require 'pp'

class WelcomeEmailTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear

    @regular_user = auth_users(:regular_user)
    @company_admin = auth_users(:company_admin_user)

    @averagejoe_access_policy = access_policies(:average_joe_access_policy_everything)

    @new = Auth::User.new

    @ph = { first_name: "Test", last_name: "User", username: "new_user",
      password: "Password1$", password_confirmation: "Password1$",
      company_admin: false, app_admin: false,
      access_policy_id: @averagejoe_access_policy.id }
    @valid_email = "a@e.c"
  end

  test "email sends if email is valid and send email is true" do
    to = CreateTO.new(@company_admin, @new, @ph, true)
    to.merge_params_hash({ email: @valid_email, send_email: true })
    to.test(self)
    assert_equal 1, ActionMailer::Base.deliveries.size
  end

  test "email doesn't send if send email is false" do
    to = CreateTO.new(@company_admin, @new, @ph, true)
    to.merge_params_hash({ email: @valid_email, send_email: false })
    to.test(self)
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "email doesn't send if email is blank" do
    to = CreateTO.new(@company_admin, @new, @ph, false)
    to.merge_params_hash({ email: "", send_email: true })
    to.add_error_to ErrorTO.new("form.errors.email.send.email_blank", :send_email)
    to.add_error_to ErrorTO.new("form.errors.email.blank", :email)
    to.test(self)
    assert_equal 0, ActionMailer::Base.deliveries.size
  end

  test "email doesn't send if email is invalid" do
    to = CreateTO.new(@company_admin, @new, @ph, false)
    to.merge_params_hash({ email: "invalid", send_email: true })
    to.add_error_to ErrorTO.new(:invalid, :email)
    to.test(self)
    assert_equal 0, ActionMailer::Base.deliveries.size
  end


end

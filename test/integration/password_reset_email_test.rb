require 'test_helper'

class PasswordResetEmailTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @company_admin = users(:company_admin_user)
    @regular_user = users(:regular_user)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to updating a password and checking if an email is sent or not.
  def update_password_as(user, update_user, parameter, email_validity)
    params = { user: parameter }
    log_in_if_user(user)
    patch user_path(update_user), xhr: true, params: params
    if email_validity == true
      assert_equal 1, ActionMailer::Base.deliveries.size
    else
      assert_equal 0, ActionMailer::Base.deliveries.size
    end
  end

  password_hash_send_email = { password: "NewPassword123$", send_email: "1" }
  password_hash_no_email = { password: "NewPassword123$", send_email: "0" }
  password_hash_send_email_no_address = { password: "NewPassword123$", send_email: "1", email: "" }
  no_password_hash_send_email = { send_email: "1" }

  test "when company admin updates user's password and wants a email sent, it sends" do
    update_password_as(@company_admin, @regular_user, password_hash_send_email, true)
  end

  test "when company admin updates a user's password and doesn't want a email sent, no email sends" do
    update_password_as(@company_admin, @regular_user, password_hash_no_email, false)
  end

  test "when a user updates their own password, no email is sent, even if it's requested" do
    update_password_as(@company_admin, @company_admin, password_hash_no_email, false)
    update_password_as(@company_admin, @company_admin, password_hash_send_email, false)
    update_password_as(@regular_user, @regular_user, password_hash_send_email, false)
  end

  test "when a company admin updates a user's password without a email address and wants a email sent, should be an error and shouldn't send." do
    @regular_user.update_attribute(:email, "")
    update_password_as(@company_admin, @regular_user, password_hash_send_email, false)
    # Email field should have an error message as well.
    assert_match /Email cannot be blank if you want to send email/, @response.body
  end

  test "when a company admin tries to blank email, reset a user's password, and wants a email sent: result should be error and no email." do
    update_password_as(@company_admin, @regular_user, password_hash_send_email_no_address, false)
    # Email field should have an error message as well.
    assert_match /Email cannot be blank if you want to send email/, @response.body
    assert_match /Send email can&#39;t send email without email address/, @response.body
  end

  test "when a regular user resets their password and tries to have an email sent, no email sends" do
    update_password_as(@cregular_user, @regular_user, password_hash_send_email, false)
  end

  test "when a company admin updates a user's password and it's the same as it is right now, an email can still send." do
    update_password_as(@regular_user, @regular_user, password_hash_no_email, false)
    update_password_as(@company_admin, @regular_user, password_hash_send_email, true)
  end

  test "when a company admin doesn't update a user's password, but wants an email sent, that should result in a error and no email" do
    update_password_as(@company_admin, @regular_user, no_password_hash_send_email, false)
    assert_match /Password didn&#39;t change.  can&#39;t send email./, @response.body
    assert_match /Send email can&#39;t send email if password doesn&#39;t change./, @response.body
  end


  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to checking for the presence of a send email checkbox.
  def edit_user_as(user, edit_user, validity)
    log_in_if_user(user)
    get edit_user_path(edit_user), xhr:true
    text_regex = /Send email with new password/
    if validity == true
      assert_match text_regex, @response.body
    else
      assert_no_match text_regex, @response.body
    end
  end

  test "checkbox to send password reset email should only show up if admin is editing a user other than themself" do
    edit_user_as(@company_admin, @regular_user, true)
    edit_user_as(@company_admin, @company_admin, false)
  end

end

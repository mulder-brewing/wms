require 'test_helper'
require 'pp'

class WelcomeEmailTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @company_admin = users(:company_admin_user)
    @regular_user = users(:regular_user)
    @company_admin_company = @company_admin.company
    @email_address = "newuser@example.com"
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to creating a user and a welcome email being sent or not.
  def create_user_as(user, create_user_username, company_id, email, send_mail, user_count_difference, email_validity)
    params = { user: { first_name: "Test", last_name: "User", username: create_user_username, password: "Password1$", company_admin: false, app_admin: false, company_id: company_id, email: email, send_email: send_mail } }
    log_in_if_user(user)
    assert_difference 'User.count', user_count_difference do
      post users_path, xhr: true, params: params
    end
    if email_validity == true
      assert_equal 1, ActionMailer::Base.deliveries.size
    else
      assert_equal 0, ActionMailer::Base.deliveries.size
    end
  end

  test "when a company admin creates a user with a email address and wants a welcome email sent, user should be created and email should send." do
    create_user_as(@company_admin, "new_user", @company_admin_company.id, @email_address, "1", 1, true)
  end

  test "when a company admin creates a user without a email address and wants a welcome email sent, user shouldn't be created and email shouldn't send." do
    create_user_as(@company_admin, "new_user", @company_admin_company.id, nil, "1", 0, false)
    # Email field should have an error message as well.
    assert_match /Email cannot be blank if you want to send email/, @response.body
  end

  test "when a company admin creates a user with a email address and doesn't want a welcome email sent, user should be created and email shouldn't send." do
    create_user_as(@company_admin, "new_user", @company_admin_company.id, @email_address, "0", 1, false)
  end

  test "checkbox to send welcome email should only show up on new modal, not the edit modal." do
    log_in_if_user(@company_admin)
    get new_user_path, xhr:true
    assert_match /Send email with login instructions/, @response.body
    get edit_user_path(@regular_user), xhr:true
    assert_no_match /Send email with login instructions/, @response.body
  end


end

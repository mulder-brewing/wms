require 'test_helper'

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
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

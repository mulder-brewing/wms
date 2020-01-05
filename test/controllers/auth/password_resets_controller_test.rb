require 'test_helper'

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = auth_users(:regular_user)
    @regular_user.update_column(:password_reset, true)

    @current_password = { password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD }
    @new_password = { password: "NewPassword123$",
      password_confirmation: "NewPassword123$" }

    @password = [:password_digest]
  end

  test "Monster test that checks the full flow of a user's password being reset and that user resetting it." do
    log_in_as(@regular_user)
    # There's 2 redirects because by default logged in redirects to root,
    # then when password_reset is true,
    # you get redirected to the reset password page.
    follow_redirect!
    assert_redirected_to edit_auth_password_reset_path(@regular_user)
    follow_redirect!
    # Should be 2 links, one being the Mulder WMS logo top left, the other being the log out link.
    assert_select 'a[href]', 2
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', root_path
    assert_select "form"
    assert_select "form input[id=auth_password_reset_password]"
    assert_select "form input[id=auth_password_reset_password_confirmation]"
    assert_select "form input[type=submit][value='#{I18n.t("auth/users.title.update_password")}']"
    # trying to load other pages should redirect the user back to password reset.
    get root_path
    assert_redirected_to edit_auth_password_reset_path(@regular_user)
    get auth_users_path
    assert_redirected_to edit_auth_password_reset_path(@regular_user)
    get edit_auth_user_path(@regular_user)
    assert_redirected_to edit_auth_password_reset_path(@regular_user)
    # user should not be able to use the same password they
    # logged in with as their new updated password.
    to = UpdateTO.new(@regular_user, @regular_user, @current_password, false)
    to.xhr = false
    to.path = auth_password_reset_path
    to.params_key = :auth_password_reset
    to.update_fields = @password
    to.add_error_to ErrorTO.new(:same, :password)
    to.test(self)
    assert_template 'auth/password_resets/edit'
    # user should be able to update their password with a new password
    to.params_hash = @new_password
    to.validity = true
    to.test(self)
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'div.alert-success', I18n.t("alert.save.password_success")
    # password_reset should be false after update.
    @regular_user.reload
    assert_equal false, @regular_user.password_reset
  end
end

require 'test_helper'

class Auth::PasswordUpdatesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = auth_users(:regular_user)
    @company_admin = auth_users(:company_admin_user)
    @other_user = auth_users(:other_company_user)

    @new = Auth::User.new
    @form = Auth::PasswordUpdateForm

    @pu = { password: "NewPassword123$",
      password_confirmation: "NewPassword123$" }
    @pu2 = { password: "NewPassword123456$#2",
      password_confirmation: "NewPassword123456$#2" }

    @password = [:password_digest]
  end

  # ----------------------------------------------------------------------------
  # Tests for edit modal

  test "user can't update password." do
    to = UpdateTO.new(@regular_user, @regular_user, @pu, false)
    to.update_fields = [:password_digest]
    to.test(self)
  end

  test "admin can't update password" do
    to = UpdateTO.new(@company_admin, @regular_user, @pu, false)
    to.update_fields = [:password_digest]
    to.test(self)
  end


end

class UserMailer < ApplicationMailer
  def create_user(user)
    @user = user
    mail to: user.email, subject: "Account created for Mulder WMS"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset for Mulder WMS"
  end
end

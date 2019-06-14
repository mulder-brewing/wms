class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.create_user.subject
  #
  def create_user(user)
    @user = user
    mail to: user.email, subject: "Account created for Mulder WMS"
  end
end

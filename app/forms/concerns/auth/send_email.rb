module Concerns::Auth::SendEmail

  private

  def email_exists_if_send_email
    if send_email? && email.blank?
      errors.add(:email, I18n.t("form.errors.email.blank"))
      errors.add(:send_email, I18n.t("form.errors.email.send.email_blank"))
    end
  end

  def send_email?
    @send_email_bool ||= ActiveModel::Type::Boolean.new.cast(send_email)
  end

  def send_user_mail(method)
    begin
      UserMailer.send(method, @user).deliver_now
      raise StandardError
    rescue
      errors.add(:send_email, I18n.t("form.errors.email.send.error"))
      raise
    end
  end

end

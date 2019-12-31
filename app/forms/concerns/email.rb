module Concerns::Email

  private

  def send_email_possible?(email, send_email)
    send_email = ActiveModel::Type::Boolean.new.cast(send_email)
    return false if email.blank? && send_email
    return true
  end

end

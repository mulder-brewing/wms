module EmailUtil

  def self.send_possible?(email, send_email)
    send_email = BooleanUtil.cast(send_email)
    return false if email.blank? && send_email
    return true
  end
  
end

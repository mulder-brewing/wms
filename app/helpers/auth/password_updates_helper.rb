module Auth::PasswordUpdatesHelper

  def password_update_title(record)
    key = "auth/password_update.title."
    key << (self?(record) ? "self" : "other")
  end
  
end

class Auth::PasswordResetPolicy < BasicRecordFormPolicy

  def edit?
    current_user?(record)
  end

  def update?
    current_user?(record)
  end

end

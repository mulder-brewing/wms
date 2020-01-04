class Auth::PasswordUpdatePolicy < BasicRecordFormPolicy

  def edit?
    check?
  end

  def update?
    check?
  end

  private

    def check?
      return true if app_admin?
      return same_company_as_current_user?(record) if company_admin?
      user == record
    end

end

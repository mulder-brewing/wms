class Auth::PasswordUpdateFormPolicy < ApplicationPolicy

  def edit?
    check?
  end

  def update?
    check?
  end

  private

    def check?
      return true if app_admin?
      return same_company_as_current_user?(record.user) if company_admin?
      user == record.user
    end

end

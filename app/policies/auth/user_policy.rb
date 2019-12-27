class Auth::UserPolicy < ApplicationPolicy

  def new?
    admin?
  end

  def create?
    admin?
  end

  def edit?
    check?
  end

  def update?
    check?
  end

  def index?
    admin?
  end

  def update_password?
    check?
  end

  def update_password_commit?
    check?
  end

  private
    def check?
      return true if app_admin?
      return same_company_as_current_user?(record) if company_admin?
      user == record
    end

  class Scope < Scope
    def resolve
      if app_admin?
        scope.all_except(current_user).order(:username)
      else
        scope.where_company_users_except(current_user).order(:username)
      end
    end
  end

end

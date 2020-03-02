class AccessPolicyPolicy < ApplicationPolicy

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

  def company?
    app_admin?
  end

  private

  def check?
    admin? && same_company_as_current_user?(record)
  end

  class Scope < Scope
    def resolve
      super.order(:description)
    end
  end


end

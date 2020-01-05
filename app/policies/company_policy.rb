class CompanyPolicy < ApplicationPolicy

  def new?
    app_admin?
  end

  def create?
    app_admin?
  end

  def edit?
    app_admin?
  end

  def update?
    app_admin?
  end

  def index?
    app_admin?
  end

  def destroy_modal?
    app_admin?
  end

  def destroy?
    app_admin?
  end

  class Scope < Scope
    def resolve
      scope.order(:name)
    end
  end

end

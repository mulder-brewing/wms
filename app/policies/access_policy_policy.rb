class AccessPolicyPolicy < ApplicationPolicy

  def new?
    check
  end

  def create?
    check
  end

  def edit?
    check
  end

  def update?
    check
  end

  def index?
    check
  end

  private
    def check
      true
    end

end

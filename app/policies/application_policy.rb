class ApplicationPolicy
  include Auth::SessionsHelper

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def current_user
    user
  end

  def index?
    Auth::AccessPolicyUtil.check?(permission)
  end

  def create?
    Auth::AccessPolicyUtil.check?(permission)
  end

  def new?
    Auth::AccessPolicyUtil.check?(permission)
  end

  def update?
    Auth::AccessPolicyUtil.check?(permission) && same_company_as_current_user?(record)
  end

  def edit?
    Auth::AccessPolicyUtil.check?(permission) && same_company_as_current_user?(record)
  end

  def show?
    Auth::AccessPolicyUtil.check?(permission) && same_company_as_current_user?(record)
  end

  def destroy?
    Auth::AccessPolicyUtil.check?(permission) && same_company_as_current_user?(record)
  end

  private
    attr_reader :permission

  class Scope
    include Auth::SessionsHelper

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def current_user
      user
    end

    def resolve
      scope.where_company(current_company_id)
    end

    private
      attr_reader :user, :scope
  end

end

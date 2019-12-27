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
    ap_check?(permission)
  end

  def create?
    ap_check?(permission) && same_company_as_current_user?(record)
  end

  def new?
    ap_check?(permission)
  end

  def update?
    ap_check?(permission) && same_company_as_current_user?(record)
  end

  def edit?
    ap_check?(permission) && same_company_as_current_user?(record)
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

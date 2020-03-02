class DockGroupPolicy < ApplicationPolicy

  def initialize(user, scope)
    @permission = :dock_groups
    super(user, scope)
  end

  class Scope < Scope
    def resolve
      super.order(:description)
    end
  end

end

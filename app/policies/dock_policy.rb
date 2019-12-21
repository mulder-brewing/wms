class DockPolicy < ApplicationPolicy

  def initialize(user, scope)
    @permission = :docks
    super(user, scope)
  end

  class Scope < Scope
    def resolve
      super.includes_dg.order("dock_groups.description asc, docks.number asc")
    end
  end

end

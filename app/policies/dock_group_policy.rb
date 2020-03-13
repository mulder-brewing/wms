class DockGroupPolicy < ApplicationPolicy

  def initialize(*)
    super
    @permission = :dock_groups
  end

  class Scope < Scope
    def resolve
      super.order(:description)
    end
  end

end

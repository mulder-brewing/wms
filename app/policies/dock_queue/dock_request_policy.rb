class DockQueue::DockRequestPolicy < ApplicationPolicy

  def initialize(user, scope)
    @permission = :dock_queue
    super(user, scope)
  end

  class Scope < Scope
    def resolve
      super.order(:created_at)
    end
  end

end

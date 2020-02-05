class DockQueue::HistoryDockRequestPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      super.order(created_at: :desc)
    end
  end

end

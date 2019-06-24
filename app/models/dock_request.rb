class DockRequest < ApplicationRecord
  attr_accessor :context

  belongs_to :dock_group

  validates :primary_reference, presence: true
  validates :dock, presence: true, if: :context_dock_assignment?

  def self.where_company_and_group(current_company_id, group_id)
    where("company_id = ? AND dock_group_id = ?", current_company_id, group_id)
  end

  private
    def context_dock_assignment?
      context == "dock_assignment"
    end
end

class Dock < ApplicationRecord
  include DockGroupChecks

  belongs_to :company
  belongs_to :dock_group
  has_many :dock_requests
  has_many :dock_request_audit_histories

  validates :number, presence: true, length: { maximum: 50 }
  validates_uniqueness_of :number, scope: :dock_group_id

  def self.where_company_includes_dock_group(current_company_id)
    includes(:dock_group).where("docks.company_id = ?", current_company_id)
  end

  def self.where_dock_group(dock_group_id)
    where("dock_group_id = ?", dock_group_id)
  end

  def self.enabled_where_dock_group(dock_group_id)
    where_dock_group(dock_group_id).enabled
  end

end

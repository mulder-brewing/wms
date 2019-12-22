class Dock < ApplicationRecord
  include DockGroupChecks

  belongs_to :company
  belongs_to :dock_group
  has_many :dock_requests, dependent: :destroy
  has_many :dock_request_audit_histories, dependent: :destroy

  validates :number, presence: true, length: { maximum: 50 }
  validates_uniqueness_of :number, scope: :dock_group_id


  def self.where_dock_group(dock_group_id)
    where("dock_group_id = ?", dock_group_id)
  end

  def self.enabled_where_dock_group(dock_group_id)
    where_dock_group(dock_group_id).enabled
  end

  def self.where_enabled(enabled)
    where("docks.enabled = ?", enabled)
  end

  def self.where_company(company_id)
    where("docks.company_id = ?", company_id)
  end

  def self.includes_dg
    includes(:dock_group)
  end

end

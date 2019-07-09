class Dock < ApplicationRecord
  belongs_to :company
  belongs_to :dock_group
  has_many :dock_requests

  validates :number, presence: true, length: { maximum: 50 }
  validates_uniqueness_of :number, scope: :dock_group_id
  validate :dock_group_matches_current_user, if: :dock_group_pre_check

  def self.where_company_includes_dock_group(current_company_id)
    includes(:dock_group).where("docks.company_id = ?", current_company_id)
  end

  def self.where_dock_group(dock_group_id)
    where("dock_group_id = ?", dock_group_id)
  end

  def self.enabled_where_dock_group(dock_group_id)
    where_dock_group(dock_group_id).enabled
  end

  private
    def dock_group_pre_check
      !dock_group_id.blank?
    end

    def dock_group_matches_current_user
      if dock_group.company_id != company_id
        errors.add(:dock_group_id, "does not belong to your company")
      end
    end
end

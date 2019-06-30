class Dock < ApplicationRecord
  belongs_to :company
  belongs_to :dock_group

  validates :number, presence: true, length: { maximum: 50 }
  validates_uniqueness_of :number, scope: :dock_group_id
  validate :dock_group_matches_current_user, if: :dock_group_pre_check

  def self.where_company_includes_dock_group(current_company_id)
    includes(:dock_group).where("docks.company_id = ?", current_company_id)
  end

  private
    def dock_group_pre_check
      DockGroup.exists?(dock_group_id)
    end

    def dock_group_matches_current_user
      if DockGroup.find_by(id: dock_group_id).company_id != company_id
        errors.add(:dock_group_id, "doesn't belong to your company")
      end
    end
end

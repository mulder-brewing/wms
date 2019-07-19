module DockGroupChecks
  extend ActiveSupport::Concern

  included do
    validate :dock_group_enabled, if: :dock_group_id_exists?
    validate :dock_group_company_match, if: :dock_group_id_exists?
  end


  private
    def dock_group_id_exists?
      !dock_group.nil?
    end

    def dock_group_enabled
      if dock_group.enabled == false
        errors.add(:base, "Dock group #{dock_group.description} is disabled.")
      end
    end

    def dock_group_company_match
      if dock_group.company_id != company_id
        errors.add(:dock_group_id, "does not belong to your company")
      end
    end
end

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
        errors.add(:dock_group_id, I18n.t("form.errors.disabled"))
      end
    end

    def dock_group_company_match
      if dock_group.company_id != company_id
        errors.add(:dock_group_id, I18n.t("form.errors.does_not_belong"))
      end
    end
end

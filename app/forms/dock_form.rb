class DockForm < BasicRecordForm

  validate :dock_group_valid

  attr_accessor :dock_groups

  delegate  :number, :number=,
            :dock_group_id, :dock_group_id=,
            :enabled, :enabled=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "Dock")
  end

  def initialize(*)
    super
    @table_class = Table::DocksIndexTable
  end

  def permitted_params
    [:number, :dock_group_id, :enabled]
  end

  def setup_variables
    @dock_groups = DockGroup.select_options(current_company_id,
      record.dock_group_id).order(:description)
    if action?(:new) && @dock_groups.length == 1
      @record.dock_group_id = @dock_groups.first.id
    end
  end

  private

  def dock_group_valid
    dock_group = DockGroup.find_by(id: dock_group_id)
    if dock_group.present?
      if dock_group.enabled == false
        errors.add(:dock_group_id, I18n.t("form.errors.disabled"))
      end
      if dock_group.company_id != @record.company_id
        errors.add(:dock_group_id, I18n.t("form.errors.does_not_belong"))
      end
    end
  end

end

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
    validate_company_id(DockGroup, :dock_group_id)
    validate_enabled(DockGroup, :dock_group_id)
  end

end

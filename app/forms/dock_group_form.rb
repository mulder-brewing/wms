class DockGroupForm < BasicRecordForm

  delegate  :description, :description=,
            :enabled, :enabled=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "DockGroup")
  end

  def initialize(*)
    super
    @table_class = Table::DockGroupsIndexTable
  end

  def permitted_params
    [:description, :enabled]
  end

end

class Table::DockGroupsIndexTable < Table::IndexTable

  def initialize(*)
    super
    buttons = [Button::IndexEditButton.new]
    @columns << Table::Column::ButtonColumn.new(buttons)
    @columns << Table::Column::DataColumn.new(t_class: DockGroup,
      attribute: :description)
    @columns << Table::Column::EnabledColumn.new
  end
  
end

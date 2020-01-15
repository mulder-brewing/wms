class Table::DockGroupsIndexTable < Table::IndexTable

  def initialize(*)
    super
    buttons = [Button::IndexEditButton.new]
    @columns << Table::Column::ButtonColumn.new(buttons)
    @columns << Table::Column::DataColumn.new(sfld("description"), :description)
    @columns << Table::Column::EnabledColumn.new
  end
end

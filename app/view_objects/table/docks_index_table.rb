class Table::DocksIndexTable < Table::IndexTable

  def initialize(*)
    super
    buttons = [Button::IndexEditButton.new]
    @columns << Table::Column::ButtonColumn.new(buttons)
    @columns << Table::Column::DataColumn.new(sfld("number"), :number)
    @columns << Table::Column::DataColumn.new("dock_groups.dock_group",
      [:dock_group, :description])
    @columns << Table::Column::EnabledColumn.new
  end
end

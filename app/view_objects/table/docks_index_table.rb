class Table::DocksIndexTable < Table::IndexTable

  def initialize(*)
    super
    buttons = [Button::IndexEditButton.new]
    @columns << Table::Column::ButtonColumn.new(buttons)
    @columns << Table::Column::DataColumn.new(t_class: Dock, attribute: :number)
    @columns << Table::Column::DataColumn.new(title: model_sing(DockGroup),
      send_chain: [:dock_group, :description])
    @columns << Table::Column::EnabledColumn.new
  end
end

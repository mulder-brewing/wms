
class Table::CompaniesIndexTable < Table::IndexTable

  def initialize(*)
    super
    buttons = [Button::IndexEditButton.new, Button::DeleteButton.new]
    @columns << Table::Column::ButtonColumn.new(buttons)
    @columns << Table::Column::DataColumn.new("global.name", :name)
    @columns << Table::Column::EnabledColumn.new
  end
end

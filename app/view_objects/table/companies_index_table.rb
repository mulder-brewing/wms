
class Table::CompaniesIndexTable < Table::IndexTable

  def initialize(*)
    super
    buttons =[]
    buttons << Button::IndexEditButton.new
    buttons << Button::IndexDeleteButton.new(destroy_path: :destroy_modal_company_path)
    @columns << Table::Column::ButtonColumn.new(buttons)
    @columns << Table::Column::DataColumn.new(t_class: Company, attribute: :name)
    @columns << Table::Column::DataColumn.new(t_class: Company, attribute: :company_type, send_chain: :type_human_readable)
    @columns << Table::Column::EnabledColumn.new
  end
end

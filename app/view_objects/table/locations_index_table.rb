class Table::LocationsIndexTable < Table::IndexTable

  def initialize(*)
    super
    @columns << Table::Column::ButtonColumn.new([Button::IndexEditButton.new])
    @columns << Table::Column::DataColumn.new(t_class: Location,
      attribute: :ref)
    @columns << Table::Column::DataColumn.new(t_class: Location,
      attribute: :name)
    @columns << Table::Column::DataColumn.new(t_class: Location,
      attribute: :city)
    @columns << Table::Column::DataColumn.new(t_class: Location,
      attribute: :state)
    @columns << Table::Column::DataColumn.new(t_class: Location,
      attribute: :country)
    @columns << Table::Column::EnabledColumn.new
  end

end

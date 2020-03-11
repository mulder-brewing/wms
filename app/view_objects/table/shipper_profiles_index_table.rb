class Table::ShipperProfilesIndexTable < Table::IndexTable

  def initialize(*)
    super
    @columns << Table::Column::ButtonColumn.new([Button::IndexEditButton.new])
    @columns << Table::Column::DataColumn.new(
      title: ShipperProfile.model_name.human,
      send_chain: [:shipper, :name]
    )
    @columns << Table::Column::EnabledColumn.new
  end

end

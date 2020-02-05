class Table::DockQueue::HistoryDockRequestsIndexTable < Table::IndexTable

  def controller_model
    DockQueue::DockRequest
  end

  def initialize(*)
    super
    c = controller_model
    @columns << Table::Column::ShowRecordColumn.new(t_class: c, attribute: :primary_reference)
    @columns << Table::Column::DataColumn.new(t_class: c, attribute: :status,
      send_chain: :status_human_readable)
    @columns << Table::Column::DataColumn.new(t_class: c, attribute: :total_time)
    @columns << Table::Column::DataColumn.new(
      title: c.human_attribute_name("status.checked_in"), attribute: :created_at)
    @columns << Table::Column::DataColumn.new(
      title: c.human_attribute_name("status.checked_out"), attribute: :checked_out_at)
  end

end

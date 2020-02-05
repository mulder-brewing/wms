class Table::DockQueue::DockRequestAuditHistoriesTable < Table::IndexTable

  def initialize(*)
    super
    @wrapper = "#dock_request_audit_history_wrapper"
    @c = DockQueue::DockRequestAuditHistory
    @columns << Table::Column::DataColumn.new(t_class: @c, attribute: :event,
      send_chain: [:event_human_readable])
    @columns << Table::Column::DataColumn.new(title: model_sing(Auth::User),
      send_chain: [:user, :full_name])
    @columns << Table::Column::DataColumn.new(title: I18n.t("global.date_time"),
      attribute: :created_at)
  end

  def prep_records(params)
    @records = @c.includes_user_dock_where_dock_request_id(params[:id])
    return records
  end

end

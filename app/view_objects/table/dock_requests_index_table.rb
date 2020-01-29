class Table::DockRequestsIndexTable < Table::IndexTable

  def initialize(*)
    super
    @insert_method = Table::Insert::APPEND
  end

  def prep_records(dock_group)
    unless dock_group.nil?
      @records = DockQueue::DockRequest.where_company_and_group(current_company_id, dock_group.id).include_docks.active
    else
      @records = DockQueue::DockRequest.none
    end
  end

  def record_html_path
    "dock_queue/dock_requests/dock_request"
  end

end

class Page::DockRequestsPage < Page::IndexListPage

  attr_accessor :dock_groups, :dock_group

  def prep_records(params)
    @new_record = DockQueue::DockRequest.new
    @dock_groups = DockGroup.enabled_where_company(current_company_id).order(:description)
    if params[:dock_request].present? && params[:dock_request][:dock_group_id].present?
      id = params[:dock_request][:dock_group_id].to_i
      @dock_group = @dock_groups.find { |dg| dg.id == id }
    end
    unless dock_group.nil?
      @records = DockQueue::DockRequest.where_company_and_group(current_company_id, dock_group.id).include_docks.active
    else
      @records = DockQueue::DockRequest.none
    end
  end

  def render_path
    "dock_queue/dock_requests/index"
  end

  def record_html_path
    "dock_queue/dock_requests/dock_request"
  end

  def dock_groups_count
    @dock_groups_count ||= dock_groups.length
  end

  def dock_group_nil?
    @dg_nil ||= dock_group.nil?
  end

  def show_dock_group_selector?
    dock_groups_count > 1
  end

  def show_new_link?
    !dock_group_nil?
  end

end

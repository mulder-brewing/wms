class Page::DockRequestsPage < Page::IndexListPage

  attr_accessor :dock_groups, :dock_group

  delegate :dg_select_id, to: :class

  def prep(params)
    @new_record = DockQueue::DockRequest.new
    @dock_groups = DockGroup.enabled_where_company(current_company_id).order(:description)
    if params[:dock_request].present? && params[:dock_request][:dock_group_id].present?
      id = params[:dock_request][:dock_group_id].to_i
      @dock_group = @dock_groups.find { |dg| dg.id == id }
    end
  end

  def self.render_path
    "dock_queue/dock_requests/index"
  end

  def self.dg_select_id
    "dock_group_select"
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

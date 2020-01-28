class DockQueue::UnassignDockForm < DockQueue::DockAssignmentForm

  def initialize(*)
    super
    @valid_status_before_change << "dock_assigned"
  end

  def view_path
    nil
  end

  private

  def private_submit
    record.status = "checked_in"
    record.dock_id = nil
    record.dock_assigned_at = nil
    super
  end

end

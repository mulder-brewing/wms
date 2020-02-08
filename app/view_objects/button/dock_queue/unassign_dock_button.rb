class Button::DockQueue::UnassignDockButton < Button::DockQueue::StatusBackButton

  BTN_CLASS = "unassign-dock-button-class"

  def initialize(*)
    super
    @text_key = "dock_queue/dock_assignments.unassign_dock"
    @card_row_btn_path = :dock_queue_dock_assignment_path
    @method = :delete
  end

end

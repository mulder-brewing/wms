class Button::DockQueue::AssignDockButton < Button::DockQueue::StatusForwardButton

  BTN_CLASS = "assign-dock-button-class"

  def initialize(*)
    super
    @text_key = "dock_queue/dock_assignments.assign_dock"
    @show_status = "checked_in"
    @card_row_btn_path = :edit_dock_queue_dock_assignment_path
  end

end

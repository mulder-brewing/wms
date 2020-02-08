class Button::DockQueue::CheckOutButton < Button::DockQueue::StatusForwardButton

  BTN_CLASS = "check-out-button-class"

  def initialize(*)
    super
    @text_key = "dock_queue/check_out_dock_requests.title.check_out"
    @card_row_btn_path = :edit_dock_queue_check_out_dock_request_path
  end

end

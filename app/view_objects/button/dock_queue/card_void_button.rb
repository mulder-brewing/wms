class Button::DockQueue::CardVoidButton < Button::DockQueue::StatusBackButton

  BTN_CLASS = "card-void-button-class"

  def initialize(*)
    super
    @text_key = "actions.void"
    @card_row_btn_path = :edit_dock_queue_void_dock_request_path
  end

end

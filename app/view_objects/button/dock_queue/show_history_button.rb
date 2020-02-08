class Button::DockQueue::ShowHistoryButton < Button::BaseButton
  include Button::BtnLinkOptions

  BTN_CLASS = "dock-request-history-button-class"
  BTN_ID = "button_show_audit_history"

  def initialize
    super
    @text_key = "global.history"
    @size = Button::Size::SMALL
    @style = Button::Style::PRIMARY
    @classes << "m-1"
    @remote = true
  end

  def record_path(record)
    PathUtil.path(:dock_queue_dock_request_audit_histories_path, id: record.id)
  end

end

class Button::DockQueue::CardRowButton < Button::BaseButton
  include Button::BtnLinkOptions

  attr_accessor :show_status, :card_row_btn_path

  def initialize
    super
    @size = Button::Size::SMALL
    @btn_class = self.class::BTN_CLASS
    @remote = true
    @block = true
  end

  def record_path(record)
    Util::Paths::Path.call(@card_row_btn_path, id: record.id)
  end

end

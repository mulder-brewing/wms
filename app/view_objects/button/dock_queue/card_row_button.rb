class Button::DockQueue::CardRowButton < Button::BaseButton
  include Button::BtnLinkOptions

  attr_accessor :card_row_btn_path

  def initialize(*)
    super
    @size = Button::Size::SMALL
    @remote = true
    @block = true
  end

  def record_path(record)
    PathUtil.path(@card_row_btn_path, id: record.id)
  end

end

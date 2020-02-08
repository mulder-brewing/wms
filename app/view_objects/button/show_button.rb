class Button::ShowButton < Button::BaseButton
  include Button::BtnLinkOptions

  BTN_CLASS = "show-button-class"

  def initialize(*)
    super
    @text_key = "actions.show"
    @style = Button::Style::PRIMARY
  end

  def record_path(record)
    PathUtil.show(record)
  end

end

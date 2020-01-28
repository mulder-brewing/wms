class Button::VoidButton < Button::BaseButton
  include Button::BtnLinkOptions

  BTN_CLASS = "void-button-class"

  def initialize(*)
    super
    @text_key = "actions.void"
    @style = Button::Style::DANGER
    @btn_class = BTN_CLASS
  end

end

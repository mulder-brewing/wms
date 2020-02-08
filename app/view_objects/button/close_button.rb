class Button::CloseButton < Button::BaseButton
  include Button::BtnOptions

  BTN_CLASS = "close-button-class"

  def initialize(*)
    super
    @text_key = "actions.close"
    @style = Button::Style::SECONDARY
  end

end

class Button::DeleteButton < Button::BaseButton
  include Button::BtnLinkOptions

  BTN_CLASS = "delete-button-class"

  def initialize(*)
    super
    @text_key = "actions.delete"
    @style = Button::Style::DANGER
  end

end

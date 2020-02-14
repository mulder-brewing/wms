class Button::DeleteButton < Button::BaseButton
  include Button::BtnLinkOptions

  def initialize(*)
    super
    @text_key = "actions.delete"
    @style = Button::Style::DANGER
  end

end

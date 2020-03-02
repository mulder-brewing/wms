class Button::CloseButton < Button::BaseButton
  include Button::BtnOptions

  def initialize(*)
    super
    @text_key = "actions.close"
    @style = Button::Style::SECONDARY
  end

end

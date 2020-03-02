class Button::SaveButton < Button::BaseButton
  include Button::BtnOptions

  def initialize(*)
    super
    @text_key = "actions.save"
    @style = Button::Style::PRIMARY
  end

end

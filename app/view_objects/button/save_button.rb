class Button::SaveButton < Button::BaseButton
  include Button::BtnOptions

  BTN_CLASS = "save-button-class"

  def initialize(*)
    super
    @text_key = "actions.save"
    @style = Button::Style::PRIMARY
    @btn_class = BTN_CLASS
  end

end

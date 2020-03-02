class Button::VoidButton < Button::BaseButton
  include Button::BtnLinkOptions

  def initialize(*)
    super
    @text_key = "actions.void"
    @style = Button::Style::DANGER
  end

end

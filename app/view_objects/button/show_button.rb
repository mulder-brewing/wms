class Button::ShowButton < Button::BaseButton
  include Button::BtnLinkOptions

  BTN_CLASS = "show-button-class"

  def initialize(*)
    super
    @text_key = "actions.show"
    @style = Button::Style::PRIMARY
    @btn_class = BTN_CLASS
  end

  def record_path(record)
    Util::Paths::Show.call(record)
  end

end

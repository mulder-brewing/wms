class Button::NewButton < Button::BaseButton
  include Button::BtnLinkOptions

  BTN_CLASS = "new-button-class"

  def initialize(*)
    super
    @text_key = "actions.new"
    @style = Button::Style::SUCCESS
    @btn_class = BTN_CLASS
  end

  def record_path(record)
    Util::Paths::New.call(record)
  end

end

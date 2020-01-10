class Button::EditButton < Button::BaseButton
  include Button::BtnLinkOptions

  BTN_CLASS = "edit-button-class"

  def initialize(*)
    super
    @text_key = "actions.edit"
    @style = Button::Style::PRIMARY
    @btn_class = BTN_CLASS
  end

  def record_path(record)
    Util::Paths::Edit.call(record)
  end

end

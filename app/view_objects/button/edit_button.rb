class Button::EditButton < Button::BaseButton
  include Button::BtnLinkOptions

  BTN_CLASS = "edit-button-class"

  def initialize(*)
    super
    @text_key = "actions.edit"
    @style = Button::Style::PRIMARY
  end

  def record_path(record)
    PathUtil.edit(record)
  end

end

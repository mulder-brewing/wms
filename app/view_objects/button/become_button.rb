class Button::BecomeButton < Button::BaseButton
  include Button::BtnLinkOptions

  BTN_CLASS = "become-user-button-class"

  def initialize(*)
    super
    @text_key = "auth/users.become"
    @style = Button::Style::PRIMARY
    @btn_class = BTN_CLASS
    index_action_style
  end

  def record_path(record)
    Util::Paths::Path.call(:become_user_path, id: record.id)
  end

end

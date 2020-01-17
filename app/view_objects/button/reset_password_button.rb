class Button::ResetPasswordButton < Button::BaseButton
  include Button::BtnLinkOptions

  BTN_CLASS = "reset-password-button-class"

  def initialize(*)
    super
    @remote = true
    @style = Button::Style::PRIMARY
    @btn_class = BTN_CLASS
    @classes << "btn-block mt-3"
  end

  def record_path(record)
    Util::Paths::Path.call(:edit_auth_password_update_path, id: record.id)
  end

end

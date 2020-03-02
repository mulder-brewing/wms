class Button::ResetPasswordButton < Button::BaseButton
  include Button::BtnLinkOptions

  def initialize(*)
    super
    @remote = true
    @style = Button::Style::PRIMARY
    @classes << "btn-block mt-3"
  end

  def record_path(record)
    PathUtil.path(:edit_auth_password_update_path, id: record.id)
  end

end

class Button::LogOutButton < Button::BaseButton
  include Button::BtnLinkOptions

  def initialize(*)
    super(
      text_key: "actions.log_out",
      style: Button::Style::PRIMARY,
      size: Button::Size::SMALL,
      class: "align-middle ml-auto order-md-last mr-3 mr-sm-4 mr-md-0"
    )
    @method = :delete
    @path = PathUtil.path(:logout_path)
  end

end

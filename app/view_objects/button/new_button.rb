class Button::NewButton < Button::BaseButton
  include Button::BtnLinkOptions

  def initialize(*)
    super
    @text_key = "actions.new"
    @style = Button::Style::SUCCESS
  end

  def record_path(record)
    PathUtil.new(record)
  end

end

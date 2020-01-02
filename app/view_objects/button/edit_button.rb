class Button::EditButton < Button::IndexButton

  def initialize(remote = true)
    super("modal.edit", Button::Style::PRIMARY)
    @remote = remote
    @size = Button::Size::SMALL
    @classes << "m-1"
  end

  def path(record)
    Util::Paths::Edit.call(record)
  end

end

class Button::BecomeButton < Button::IndexButton

  def initialize
    super("auth/users.become", Button::Style::PRIMARY)
    @size = Button::Size::SMALL
    @classes << "m-1"
  end

  def path(record)
    Util::Paths::Path.call(:become_user_path, id: record.id)
  end

end

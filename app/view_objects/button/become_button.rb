class Button::BecomeButton < Button::BaseButton

  TEST_ID = "become-user-button-test-id"

  def initialize
    super("auth/users.become", Button::Style::PRIMARY)
    @size = Button::Size::SMALL
    @classes << "m-1"
    @classes << TEST_ID
  end

  def path(record)
    Util::Paths::Path.call(:become_user_path, id: record.id)
  end

end

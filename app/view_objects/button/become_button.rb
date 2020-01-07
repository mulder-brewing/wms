class Button::BecomeButton < Button::BaseButton

  TEST_ID = "become-user-button-test-id"

  def initialize(**options)
    super("auth/users.become", Button::Style::PRIMARY, options)
    @size = Button::Size::SMALL
    @classes << "m-1"
    @test_id = TEST_ID
  end

  def path(record)
    Util::Paths::Path.call(:become_user_path, id: record.id)
  end

end

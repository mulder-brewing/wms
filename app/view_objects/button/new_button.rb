class Button::NewButton < Button::BaseButton

  TEST_ID = "new-button-test-id"

  def initialize(**options)
    super("actions.new", Button::Style::SUCCESS, options)
    @remote = true
    @size = Button::Size::SMALL
    @test_id = TEST_ID
  end

  def path(record)
    Util::Paths::New.call(record)
  end

end

class Button::EditButton < Button::BaseButton

  TEST_ID = "edit-button-test-id"

  def initialize(**options)
    super("actions.edit", Button::Style::PRIMARY, options)
    @test_id = TEST_ID
  end

  def path(record)
    Util::Paths::Edit.call(record)
  end

end

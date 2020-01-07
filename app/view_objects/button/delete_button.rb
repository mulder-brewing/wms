class Button::DeleteButton < Button::BaseButton

  TEST_ID = "delete-button-test-id"

  def initialize(**options)
    super("actions.delete", Button::Style::DANGER, options)
    @remote = true
    @size = Button::Size::SMALL
    @classes << "m-1"
    @test_id = TEST_ID
  end

  def path(record)
    Util::Paths::Path.call(:destroy_modal_company_path, id: record.id)
  end

end

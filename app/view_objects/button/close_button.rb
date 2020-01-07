class Button::CloseButton < Button::BaseButton

  TEST_ID = "close-button-test-id"

  def initialize(**options)
    super("actions.close", Button::Style::SECONDARY, options)
    @classes << "m-1"
    @test_id = "close-button-test-id"
  end

  def path(record)
    Util::Paths::Path.call(:destroy_modal_company_path, id: record.id)
  end

end

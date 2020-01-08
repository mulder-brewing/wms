class Button::NewButton < Button::BaseButton
  include Button::BtnLinkOptions

  TEST_ID = "new-button-test-id"

  def initialize(*)
    super
    @text_key = "actions.new"
    @style = Button::Style::SUCCESS
    @test_id = TEST_ID
  end

  def record_path(record)
    Util::Paths::New.call(record)
  end

end

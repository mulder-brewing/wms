class Button::CloseButton < Button::BaseButton
  include Button::BtnOptions

  TEST_ID = "close-button-test-id"

  def initialize(*)
    super
    @text_key = "actions.close"
    @style = Button::Style::SECONDARY
    @test_id = TEST_ID
  end

end

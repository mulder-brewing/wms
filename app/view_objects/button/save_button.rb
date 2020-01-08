class Button::SaveButton < Button::BaseButton
  include Button::BtnOptions

  TEST_ID = "save-button-test-id"

  def initialize(*)
    super
    @text_key = "actions.save"
    @style = Button::Style::PRIMARY
    @test_id = TEST_ID
  end

end

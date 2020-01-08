class Button::DeleteButton < Button::BaseButton
  include Button::BtnLinkOptions

  TEST_ID = "delete-button-test-id"

  def initialize(*)
    super
    @text_key = "actions.delete"
    @style = Button::Style::DANGER
    @test_id = TEST_ID
  end

end

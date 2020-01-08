class Button::EditButton < Button::BaseButton
  include Button::BtnLinkOptions

  TEST_ID = "edit-button-test-id"

  def initialize(*)
    super
    @text_key = "actions.edit"
    @style = Button::Style::PRIMARY
    @test_id = TEST_ID
  end

  def record_path(record)
    Util::Paths::Edit.call(record)
  end

end

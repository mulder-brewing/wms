class Button::BecomeButton < Button::BaseButton
  include Button::BtnLinkOptions

  TEST_ID = "become-user-button-test-id"

  def initialize(*)
    super
    @text_key = "auth/users.become"
    @style = Button::Style::PRIMARY
    @test_id = TEST_ID
    index_action_style
  end

  def record_path(record)
    Util::Paths::Path.call(:become_user_path, id: record.id)
  end

end

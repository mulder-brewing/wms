require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def setup
    @regular_user = users(:regular_user)
  end

  test "create_user" do
    @regular_user.password = "Testpassword1$$"
    mail = UserMailer.create_user(@regular_user)
    assert_equal "Account created for Mulder WMS", mail.subject
    assert_equal [@regular_user.email], mail.to
    assert_equal ["no-reply@mulderwms.net"], mail.from
    assert_match @regular_user.full_name, mail.body.encoded
    assert_match @regular_user.username, mail.body.encoded
    assert_match @regular_user.password, mail.body.encoded
  end

end

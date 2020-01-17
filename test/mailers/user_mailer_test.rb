require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def setup
    @regular_user = auth_users(:regular_user)
    @regular_user.password = "Testpassword1$$"
  end

  def check_email(mail, user, subject)
    assert_equal subject, mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["no-reply@mulderwms.net"], mail.from
    assert_match user.full_name, mail.body.encoded
    assert_match user.username, mail.body.encoded
    assert_match user.password, mail.body.encoded
  end

  test "create_user" do
    mail = UserMailer.create_user(@regular_user)
    check_email(mail, @regular_user, "Account created for Mulder WMS")
  end

  test "password_reset" do
    mail = UserMailer.password_reset(@regular_user)
    check_email(mail, @regular_user, "Password reset for Mulder WMS")
  end
end

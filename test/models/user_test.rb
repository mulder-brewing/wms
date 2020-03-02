require 'test_helper'
require 'pp'

class UserTest < ActiveSupport::TestCase

  def setup
    @regular_user = auth_users(:regular_user)
    @company_admin = auth_users(:company_admin_user)
    @other_company_user = auth_users(:other_company_user)
  end

  test "whitespace should be stripped from beginning and end" do

    @regular_user.assign_attributes( { first_name: "  /t /n  test    ", last_name: "   /t   user /n  ", email: "  test@regularuser.com   " } )
    assert @regular_user.valid?
  end

  test "user must have a company id" do
    @regular_user.company_id = ""
    assert_not @regular_user.valid?
    @regular_user.company_id = nil
    assert_not @regular_user.valid?
  end

  test "user must have a username" do
    @regular_user.username = ""
    assert_not @regular_user.valid?
    @regular_user.username = nil
    assert_not @regular_user.valid?
  end

  test "username must not exceed 50 characters" do
    @regular_user.username = "a" * 50
    assert @regular_user.valid?
    @regular_user.username = "a" * 51
    assert_not @regular_user.valid?
  end

  test "username must be only lowercase, numbers, and underscore with no spaces." do
    @regular_user.username = "UniQuE"
    assert_not @regular_user.valid?
    @regular_user.username = "unique@"
    assert_not @regular_user.valid?
    @regular_user.username = "UNIQUE"
    assert_not @regular_user.valid?
    @regular_user.username = "uni que"
    assert_not @regular_user.valid?
    @regular_user.username = " unique_78 "
    assert_not @regular_user.valid?
    @regular_user.username = "unique_78"
    assert @regular_user.valid?
  end

  test "first name must exist and be 50 characters or less" do
    @regular_user.first_name = ""
    assert_not @regular_user.valid?
    @regular_user.first_name = nil
    assert_not @regular_user.valid?
    @regular_user.first_name = "a" * 51
    assert_not @regular_user.valid?
    @regular_user.first_name = "a" * 50
    assert @regular_user.valid?
  end

  test "last name must exist and be 50 characters or less" do
    @regular_user.last_name = ""
    assert_not @regular_user.valid?
    @regular_user.last_name = nil
    assert_not @regular_user.valid?
    @regular_user.last_name = "a" * 51
    assert_not @regular_user.valid?
    @regular_user.last_name = "a" * 50
    assert @regular_user.valid?
  end

  test "if email is present, it must be in a good format" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com FOO@BAR..COM user@@example.com]
    invalid_addresses.each do |invalid_address|
      @regular_user.email = invalid_address
      assert_not @regular_user.valid?, "#{invalid_address.inspect} should be invalid"
    end
    valid_addresses = [nil,"", "foo@bar.com" ,"user@example.com", "foo@foobar.COM", "librarian123@library.org", "alice@baz.cn"]
    valid_addresses.each do |valid_address|
      @regular_user.email = valid_address
      assert @regular_user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "password must be present, 8-64 characters : have at least one uppercase, lowercase, number, and special character" do
    invalid_passwords = ["Abc123#", "Abc12345", " Abc1234$", "Abc1234$ ", "Abc 12345$", "abc12345$", "ABC12345$", "Abcdefghijk$"]
    invalid_passwords.each do |password|
      @regular_user.password = password
      assert_not @regular_user.valid?, "#{password.inspect} should be invalid."
    end
    valid_passwords = %w[Password1$ Abc1234* %BATs1234 |||Poo12]
    valid_passwords.each do |password|
      @regular_user.password = password
      assert@regular_user.valid?, "#{password.inspect} should be valid"
    end
  end

  test "full_name" do
    assert_match @regular_user.full_name, "Average Joe"
  end

  test "all except user scope" do
    assert Auth::User.all_except(@regular_user).find_by(id: @regular_user.id).nil?
  end

  test "where company users except user scope" do
    users =  Auth::User.where_company_users_except(@regular_user)
    assert users.find_by(id: @regular_user.id).nil?
    assert users.find_by(id: @other_company_user.id).nil?
    assert_not users.find_by(id: @company_admin.id).nil?
  end


end

require 'test_helper'
require 'pp'

class DockQueue::DockRequestTest < ActiveSupport::TestCase
  def setup
    @dock_request_1 = dock_queue_dock_requests(:dock_request_1)
    @average_joe_dock = docks(:average_joe_dock)
  end

  def assert_invalid
    assert !@dock_request_1.valid?
  end

  def assert_valid
    assert @dock_request_1.valid?
  end

  test "a dock request without a primary reference is invalid" do
    @dock_request_1.update_attribute(:primary_reference, nil)
    assert_invalid
    @dock_request_1.update_attribute(:primary_reference, "")
    assert_invalid
  end

  test "a 10 digit phone number is valid" do
    @dock_request_1.phone_number = "1" * 11
    assert_invalid
    @dock_request_1.phone_number = "1" * 9
    assert_invalid
    @dock_request_1.phone_number = "1" * 10
    assert_valid
  end

  test "a blank phone number is valid" do
    @dock_request_1.phone_number = ""
    assert_valid
    @dock_request_1.phone_number = nil
    assert_valid
  end

  test "anything except digits will be stripped from the phone number" do
    @dock_request_1.phone_number = "abn345ookk^^??!~~~666(2)312"
    @dock_request_1.valid?
    assert_equal "3456662312", @dock_request_1.phone_number
  end

end

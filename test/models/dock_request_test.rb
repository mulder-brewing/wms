require 'test_helper'
require 'pp'

class DockRequestTest < ActiveSupport::TestCase
  def setup
    @dock_request_1 = dock_requests(:dock_request_1)
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

  test "a dock request is invalid without a dock_id if the context is dock_assignment_update" do
    @dock_request_1.context = "dock_assignment_update"
    assert_invalid
    assert @dock_request_1.errors.added? :dock_id, "can't be blank"
  end

  test "a dock request is valid with a dock_id if the context is dock_assignment_update" do
    @dock_request_1.context = "dock_assignment_update"
    @dock_request_1.dock_id = @average_joe_dock.id
    assert_valid
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

  test "a blank phone number is invalid if text message is true" do
    @dock_request_1.phone_number = ""
    @dock_request_1.text_message = true
    assert_invalid
  end

  test "anything except digits will be stripped from the phone number" do
    @dock_request_1.phone_number = "abn345ookk^^??!~~~666(2)312"
    @dock_request_1.valid?
    assert_equal "3456662312", @dock_request_1.phone_number
  end

  def invalid_context_with_status(context, status)
    @dock_request_1.context = context
    @dock_request_1.status = status
    assert_invalid
    assert @dock_request_1.errors.added? :status, DockRequest.status_error_checked_out_or_voided
  end
  
  test "if context is edit or update with status checked out or voided, it will be invalid" do
    invalid_context_with_status("edit", "checked_out")
    invalid_context_with_status("edit", "voided")
    invalid_context_with_status("update", "checked_out")
    invalid_context_with_status("update", "voided")
  end
end

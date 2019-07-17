require 'test_helper'
require 'pp'

class DockRequestAuditHistoryTest < ActiveSupport::TestCase

  def setup
    @dock_request_audit_entry_checked_in = dock_request_audit_histories(:dock_request_audit_entry_checked_in)
    @dock_request_audit_entry_dock_assigned = dock_request_audit_histories(:dock_request_audit_entry_dock_assigned)
    @dock_request_audit_entry_text_message_sent = dock_request_audit_histories(:dock_request_audit_entry_text_message_sent)
  end

  test "a dock request audit entry is invalid without a dock_request_id" do
    invalid_without(@dock_request_audit_entry_checked_in, "dock_request_id")
  end

  test "a dock request audit entry is invalid without a company_id" do
    invalid_without(@dock_request_audit_entry_checked_in, "company_id")
  end

  test "a dock request audit entry is invalid without a event" do
    invalid_without(@dock_request_audit_entry_checked_in, "event")
  end

  test "a dock request audit entry is invalid if the event is dock_assigned and there isn't a dock_id" do
    invalid_without(@dock_request_audit_entry_dock_assigned, "dock_id")
  end

  test "a dock request audit entry is invalid if the event is text_message_sent and there is no phone_number" do
    invalid_without(@dock_request_audit_entry_text_message_sent, "phone_number")
  end


end

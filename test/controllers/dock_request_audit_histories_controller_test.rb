require 'test_helper'
require 'pp'

class DockRequestAuditHistoriesControllerTest < ActionDispatch::IntegrationTest

  def setup
    # users
      # These users belong to averagejoes company
      @regular_user = users(:regular_user)

    # dock_requests
      # These dock requests belongs to averagejoes company
      @dock_request_1 = dock_requests(:dock_request_1)
      # These belong to other company
      @dock_request_2 = dock_requests(:dock_request_2)

    # dock_request_audit_histories
      # These belong to dock_request_1 and averagejoe company
      @dock_request_audit_entry_checked_in = dock_request_audit_histories(:dock_request_audit_entry_checked_in)
      @dock_request_audit_entry_dock_assigned = dock_request_audit_histories(:dock_request_audit_entry_dock_assigned)
      @dock_request_audit_entry_text_message_sent = dock_request_audit_histories(:dock_request_audit_entry_text_message_sent)
      # These belong to dock_request_3 and averagejoe company
      @dock_request_audit_entry_dock_request_3 = dock_request_audit_histories(:dock_request_audit_entry_dock_request_3)
      # These belong to delete_me_dock_request and company_to_delete
      @delete_me_dock_request_audit_entry = dock_request_audit_histories(:delete_me_dock_request_audit_entry)
      # These belong to dock_request_2 and other_company
      @dock_request_audit_entry_other_company = dock_request_audit_histories(:dock_request_audit_entry_other_company)


  end

  test "a logged out user should not be able to get audit history for a dock request" do
    index_objects(nil, dock_request_audit_histories_index_path(id: @dock_request_1.id), "dock_request_audit_histories/index", false, { :xhr => true })
  end

  test "a logged in user should not be able to get audit history for another company's dock request" do
    index_objects(@regular_user, dock_request_audit_histories_index_path(id: @dock_request_2.id), "dock_request_audit_histories/index", false, { :xhr => true })
  end

  test "a logged in user should be able to get audit history for a dock request and only see entries for that dock request" do
    index_objects(@regular_user, dock_request_audit_histories_index_path(id: @dock_request_1.id), "dock_request_audit_histories/index", true, { :xhr => true })
    # should see this dock request from dock_request_1
    verify_assert_match "dock_request_audit_history_#{@dock_request_audit_entry_checked_in.id}"
    verify_assert_match "dock_request_audit_history_#{@dock_request_audit_entry_dock_assigned.id}"
    verify_assert_match "dock_request_audit_history_#{@dock_request_audit_entry_text_message_sent.id}"
    # should not see this one that is from same company but another dock_request
    verify_assert_no_match "dock_request_audit_history_#{@dock_request_audit_entry_dock_request_3.id}"
    # should not see these another company
    verify_assert_no_match "dock_request_audit_history_#{@delete_me_dock_request_audit_entry.id}"
    verify_assert_no_match "dock_request_audit_history_#{@dock_request_audit_entry_other_company.id}"
  end

end

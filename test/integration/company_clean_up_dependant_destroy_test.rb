require 'test_helper'

class CompanyCleanUpDependantDestroyTest < ActionDispatch::IntegrationTest
  def setup
    @company_to_delete = companies(:company_to_delete)
    @delete_me_user = auth_users(:delete_me_user)
    @delete_me_dock_group = dock_groups(:delete_me_dock_group)
    @delete_me_dock = docks(:delete_me_dock)
    @delete_me_dock_request = dock_queue_dock_requests(:delete_me_dock_request)
    @delete_me_dock_request_audit_entry = dock_queue_dock_request_audit_histories(:delete_me_dock_request_audit_entry)
    @delete_me_access_policy = access_policies(:delete_me_access_policy)

  end

  test "deleting a company cleans up all the dependent destroys" do
    @company_to_delete.destroy
    assert !Company.exists?(@company_to_delete.id)
    assert !Auth::User.exists?(@delete_me_user.id)
    assert !DockGroup.exists?(@delete_me_dock_group.id)
    assert !Dock.exists?(@delete_me_dock.id)
    assert !DockQueue::DockRequest.exists?(@delete_me_dock_request.id)
    assert !DockQueue::DockRequestAuditHistory.exists?(@delete_me_dock_request_audit_entry.id)
    assert !AccessPolicy.exists?(@delete_me_access_policy.id)
  end
end

require 'test_helper'
include DockQueueTestHelper

class DockQueue::DockUnassignmentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @form = DockQueue::UnassignDockForm

    @record_1 = dock_queue_dock_requests(:dock_request_1)
    @other_record_1 = dock_queue_dock_requests(:dock_request_2)
    @dock_assigned = dock_queue_dock_requests(:dock_request_dock_assigned)
    @checked_out = dock_queue_dock_requests(:dock_request_checked_out)
    @voided = dock_queue_dock_requests(:dock_request_voided)

    @nothing_ap_user = auth_users(:nothing_ap_user)
    @everything_ap_user = auth_users(:everything_ap_user)

    @controller = "dock_queue/dock_unassignments"

    @p = {}

    @update_fields = [:dock_id, :status, :dock_assigned_at]
  end

  # ----------------------------------------------------------------------------
  # Tests for assign dock (update action)

  test "a logged out user can't unassign dock" do
    to = UpdateTO.new(nil, @dock_assigned, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a nothing ap user can't unassign dock" do
    to = UpdateTO.new(@nothing_ap_user, @dock_assigned, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "everything ap user can unassign a dock" do
    to = UpdateTO.new(@everything_ap_user, @dock_assigned, true, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "trying to unassign dock for a checked in record results in stale data alert" do
    to = UpdateTO.new(@everything_ap_user, @record_1, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
    assert_stale_alert(@record_1)
  end

  test "trying to unassign dock a checked out record results in stale data alert" do
    to = UpdateTO.new(@everything_ap_user, @checked_out, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
    assert_stale_alert(@checked_out)
  end

  test "trying to unassign dock a voided record results in stale data alert" do
    to = UpdateTO.new(@everything_ap_user, @voided, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
    assert_stale_alert(@voided)
  end

  test "a everything ap(disabled) user can't unassign dock" do
    to = UpdateTO.new(@everything_ap_user, @dock_assigned, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can unassign dock" do
    to = UpdateTO.new(@nothing_ap_user, @dock_assigned, true, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't unassign dock" do
    to = UpdateTO.new(@nothing_ap_user, @dock_assigned, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't unassign dock for other company's record" do
    @other_record_1.status_dock_assigned!
    to = UpdateTO.new(@everything_ap_user, @other_record_1, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "user is warned about a deleted/not found record for update" do
    to = UpdateTO.new(@everything_ap_user, @dock_assigned, nil, params: @p,
      controller: @controller, form_class: @form)
    to.test_nf(self)
  end

end

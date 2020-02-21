require 'test_helper'
include DockQueueTestHelper

class DockQueue::VoidDockRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @record_1 = dock_queue_dock_requests(:dock_request_1)
    @other_record_1 = dock_queue_dock_requests(:dock_request_2)
    @dock_assigned = dock_queue_dock_requests(:dock_request_dock_assigned)
    @checked_out = dock_queue_dock_requests(:dock_request_checked_out)
    @voided = dock_queue_dock_requests(:dock_request_voided)

    @nothing_ap_user = auth_users(:nothing_ap_user)
    @everything_ap_user = auth_users(:everything_ap_user)

    @controller = "dock_queue/void_dock_requests"

    @p = {}

    @update_fields = [:status]
  end

  # ----------------------------------------------------------------------------
  # Tests for void modal (edit action)

  test "logged out user can't get void modal" do
    EditTO.new(nil, @record_1, false, controller: @controller).test(self)
  end

  test "a nothing ap user can't get void modal" do
    EditTO.new(@nothing_ap_user, @record_1, false, controller: @controller).test(self)
  end

  test "a everything ap user can get the void modal" do
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.test(self)
  end

  test "modal body is visible" do
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.visibles << ModalBodyVisible.new
    to.test(self)
  end

  test "trying to void(edit) a dock assigned record results in stale data alert" do
    to = EditTO.new(@everything_ap_user, @dock_assigned, true, controller: @controller)
    to.test(self)
    assert_stale_alert(@dock_assigned)
  end

  test "trying to void(edit) a checked out record results in stale data alert" do
    to = EditTO.new(@everything_ap_user, @checked_out, true, controller: @controller)
    to.test(self)
    assert_stale_alert(@checked_out)
  end

  test "trying to void(edit) a voided record results in stale data alert" do
    to = EditTO.new(@everything_ap_user, @voided, true, controller: @controller)
    to.test(self)
    assert_stale_alert(@voided)
  end

  test "a everything ap(disabled) user can't get the void modal" do
    to = EditTO.new(@everything_ap_user, @record_1, false, controller: @controller)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can get the void modal" do
    to = EditTO.new(@nothing_ap_user, @record_1, true, controller: @controller)
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't get the void modal" do
    to = EditTO.new(@nothing_ap_user, @record_1, false, controller: @controller)
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't get void modal for another company" do
    EditTO.new(@everything_ap_user, @other_record_1, false, controller: @controller).test(self)
  end

  test "user is warned about a deleted/not found record for void modal" do
    to = EditTO.new(@everything_ap_user, @record_1, nil, controller: @controller)
    to.test_nf(self)
  end

  test "void modal title" do
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.visibles << VoidModalTitleVisible.new(model_class: DockQueue::DockRequest)
    to.test(self)
  end

  test "void modal buttons" do
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.visibles << ModalFooterVisible.new(class: Button::ModalVoidButton.class_name)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
    to.test(self)
  end

  test "void modal timestamps are not visible" do
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.visibles << ModalTimestampsVisible.new(visible: false)
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for void modal (update action)

  test "a logged out user can't void a dock request" do
    to = UpdateTO.new(nil, @record_1, false, params: @p, controller: @controller)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a nothing ap user can't void a dock request" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, false, params: @p, controller: @controller)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "everything ap user can void a dock request" do
    to = UpdateTO.new(@everything_ap_user, @record_1, true, params: @p, controller: @controller)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "trying to void(update) a dock assigned record results in stale data alert" do
    to = UpdateTO.new(@everything_ap_user, @dock_assigned, false, params: @p, controller: @controller)
    to.update_fields = @update_fields
    to.test(self)
    assert_stale_alert(@dock_assigned)
  end

  test "trying to void(update) a checked out record results in stale data alert" do
    @record_1.status_checked_out!
    to = UpdateTO.new(@everything_ap_user, @checked_out, false, params: @p, controller: @controller)
    to.update_fields = @update_fields
    to.test(self)
    assert_stale_alert(@checked_out)
  end

  test "trying to void(update) a voided record results in stale data alert" do
    @record_1.status_voided!
    to = UpdateTO.new(@everything_ap_user, @voided, false, params: @p, controller: @controller)
    to.update_fields = @update_fields
    to.test(self)
    assert_stale_alert(@voided)
  end

  test "a everything ap(disabled) user can't void a dock request" do
    to = UpdateTO.new(@everything_ap_user, @record_1, false, params: @p, controller: @controller)
    to.update_fields = @update_fields
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can void a dock request" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, true, params: @p, controller: @controller)
    to.update_fields = @update_fields
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't void a dock request" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, false, params: @p, controller: @controller)
    to.update_fields = @update_fields
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't void a dock request other company's record" do
    to = UpdateTO.new(@everything_ap_user, @other_record_1, false, params: @p, controller: @controller)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "user is warned about a deleted/not found record for update" do
    to = UpdateTO.new(@everything_ap_user, @record_1, nil, params: @p, controller: @controller)
    to.test_nf(self)
  end

end

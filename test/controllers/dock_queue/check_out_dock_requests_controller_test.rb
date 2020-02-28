require 'test_helper'
include DockQueueTestHelper

class DockQueue::CheckOutDockRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @form = DockQueue::CheckOutDockRequestForm

    @record_1 = dock_queue_dock_requests(:dock_request_1)
    @other_record_1 = dock_queue_dock_requests(:dock_request_2)
    @dock_assigned = dock_queue_dock_requests(:dock_request_dock_assigned)
    @checked_out = dock_queue_dock_requests(:dock_request_checked_out)
    @voided = dock_queue_dock_requests(:dock_request_voided)

    @dock_1 = docks(:average_joe_dock)
    @disabled_dock = docks(:disabled_dock)
    @other_dock = docks(:other_dock)

    @nothing_ap_user = auth_users(:nothing_ap_user)
    @everything_ap_user = auth_users(:everything_ap_user)

    @controller = "dock_queue/check_out_dock_requests"

    @p = {}

    @update_fields = [:status, :checked_out_at]
  end

  # ----------------------------------------------------------------------------
  # Tests for check out modal (edit action)

  test "logged out user can't get edit modal" do
    EditTO.new(nil, @dock_assigned, false, controller: @controller).test(self)
  end

  test "a nothing ap user can't get edit modal" do
    EditTO.new(@nothing_ap_user, @dock_assigned, false, controller: @controller).test(self)
  end

  test "a everything ap user can get the edit modal" do
    to = EditTO.new(@everything_ap_user, @dock_assigned, true, controller: @controller)
    to.visibles << ModalBodyVisible.new
    to.test(self)
  end

  test "checked in record results in stale data alert" do
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.test(self)
    assert_stale_alert(@record_1)
  end

  test "checked out record results in stale data alert" do
    to = EditTO.new(@everything_ap_user, @checked_out, true, controller: @controller)
    to.test(self)
    assert_stale_alert(@checked_out)
  end

  test "voided record results in stale data alert" do
    to = EditTO.new(@everything_ap_user, @voided, true, controller: @controller)
    to.test(self)
    assert_stale_alert(@voided)
  end

  test "a everything ap(disabled) user can't get edit modal" do
    to = EditTO.new(@everything_ap_user, @dock_assigned, false, controller: @controller)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can get the edit modal" do
    to = EditTO.new(@nothing_ap_user, @dock_assigned, true, controller: @controller)
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't get the edit modal" do
    to = EditTO.new(@nothing_ap_user, @dock_assigned, false, controller: @controller)
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't get edit modal for another company" do
    @other_record_1.status_dock_assigned!
    EditTO.new(@everything_ap_user, @other_record_1, false, controller: @controller).test(self)
  end

  test "user is warned about a deleted/not found record for edit modal" do
    to = EditTO.new(@everything_ap_user, @dock_assigned, nil, controller: @controller)
    to.test_nf(self)
  end

  test "edit modal title" do
    to = EditTO.new(@everything_ap_user, @dock_assigned, true, controller: @controller)
    to.visibles << ModalTitleVisible.new(text: "dock_queue/check_out_dock_requests.title.check_out")
    to.test(self)
  end

  test "edit modal buttons" do
    to = EditTO.new(@everything_ap_user, @dock_assigned, true, controller: @controller)
    to.visibles << ModalFooterVisible.new(class: Button::ModalSaveButton.class_name)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
    to.test(self)
  end

  test "edit modal timestamps are not visible" do
    to = EditTO.new(@everything_ap_user, @dock_assigned, true, controller: @controller)
    to.visibles << ModalTimestampsVisible.new(visible: false)
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for check out (update action)

  test "a logged out user can't check out" do
    to = UpdateTO.new(nil, @dock_assigned, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a nothing ap user can't check out" do
    to = UpdateTO.new(@nothing_ap_user, @dock_assigned, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "everything ap user can check out" do
    to = UpdateTO.new(@everything_ap_user, @dock_assigned, true, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "trying to check out for a checked in record results in stale data alert" do
    to = UpdateTO.new(@everything_ap_user, @record_1, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
    assert_stale_alert(@record_1)
  end

  test "trying to check out a checked out record results in stale data alert" do
    to = UpdateTO.new(@everything_ap_user, @checked_out, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
    assert_stale_alert(@checked_out)
  end

  test "trying to check out a voided record results in stale data alert" do
    to = UpdateTO.new(@everything_ap_user, @voided, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
    assert_stale_alert(@voided)
  end

  test "a everything ap(disabled) user can't check out" do
    to = UpdateTO.new(@everything_ap_user, @dock_assigned, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can check out" do
    to = UpdateTO.new(@nothing_ap_user, @dock_assigned, true, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't check out" do
    to = UpdateTO.new(@nothing_ap_user, @dock_assigned, false, params: @p,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't check out for other company's record" do
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

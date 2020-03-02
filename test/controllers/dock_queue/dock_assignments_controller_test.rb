require 'test_helper'
include DockQueueTestHelper

class DockQueue::DockAssignmentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @form = DockQueue::AssignDockForm

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

    @controller = "dock_queue/dock_assignments"

    @phu = { dock_id: @dock_1.id }
    @phu_other = { dock_id: @other_dock.id }

    @update_fields = [:dock_id, :status, :dock_assigned_at]
  end

  # ----------------------------------------------------------------------------
  # Tests for assign dock modal (edit action)

  test "logged out user can't get edit modal" do
    EditTO.new(nil, @record_1, false, controller: @controller).test(self)
  end

  test "a nothing ap user can't get edit modal" do
    EditTO.new(@nothing_ap_user, @record_1, false, controller: @controller).test(self)
  end

  test "a everything ap user can get the edit modal" do
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.test(self)
  end

  test "modal body is visible" do
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.visibles << ModalBodyVisible.new
    to.test(self)
  end

  test "dock assigned record results in stale data alert" do
    to = EditTO.new(@everything_ap_user, @dock_assigned, true, controller: @controller)
    to.test(self)
    assert_stale_alert(@dock_assigned)
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
    to = EditTO.new(@everything_ap_user, @record_1, false, controller: @controller)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can get the edit modal" do
    to = EditTO.new(@nothing_ap_user, @record_1, true, controller: @controller)
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't get the edit modal" do
    to = EditTO.new(@nothing_ap_user, @record_1, false, controller: @controller)
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't get edit modal for another company" do
    EditTO.new(@everything_ap_user, @other_record_1, false, controller: @controller).test(self)
  end

  test "user is warned about a deleted/not found record for edit modal" do
    to = EditTO.new(@everything_ap_user, @record_1, nil, controller: @controller)
    to.test_nf(self)
  end

  test "edit modal title" do
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.visibles << ModalTitleVisible.new(text: "dock_queue/dock_assignments.assign_dock")
    to.test(self)
  end

  test "edit modal buttons" do
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.visibles << ModalFooterVisible.new(class: Button::ModalSaveButton.class_name)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
    to.test(self)
  end

  test "edit modal timestamps are not visible" do
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.visibles << ModalTimestampsVisible.new(visible: false)
    to.test(self)
  end

  test "enabled dock is in selector" do
    assert @dock_1.enabled
    assert_equal @record_1.dock_group_id, @dock_1.dock_group_id
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    text = @dock_1.number
    id = @dock_1.id
    to.visibles << FormSelectOptionVisible.new(form: @form,
      field: :dock_id, text: text, option_id: id, count: 1)
    to.test(self)
  end

  test "disabled dock not in selector" do
    assert_not @disabled_dock.enabled
    assert_equal @record_1.dock_group_id, @disabled_dock.dock_group_id
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    text = @disabled_dock.number
    id = @disabled_dock.id
    to.visibles << FormSelectOptionVisible.new(form: @form,
      field: :dock_id, text: text, option_id: id, count: 0)
    to.test(self)
  end

  test "if there's no phone number, the option to send a text message is not there" do
    @record_1.update_column(:phone_number, nil)
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.visibles << FormFieldVisible.new(form: @form, field: :text_message, visible: false)
    to.test(self)
  end

  test "if there's a phone number, the option to send a text message is there" do
    assert_match /\A\d{10}\z/, @record_1.phone_number
    to = EditTO.new(@everything_ap_user, @record_1, true, controller: @controller)
    to.visibles << FormFieldVisible.new(form: @form, field: :text_message)
    to.test(self)
    # phone number is visible as well.
    assert_match @record_1.phone_number, response.body
  end

  # ----------------------------------------------------------------------------
  # Tests for assign dock (update action)

  test "a logged out user can't assign dock" do
    to = UpdateTO.new(nil, @record_1, false, params_hash: @phu,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a nothing ap user can't assign dock" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, false, params_hash: @phu,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "everything ap user can assign a dock" do
    to = UpdateTO.new(@everything_ap_user, @record_1, true, params_hash: @phu,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "trying to assign dock for a dock assigned record results in stale data alert" do
    to = UpdateTO.new(@everything_ap_user, @dock_assigned, false, params_hash: @phu,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
    assert_stale_alert(@dock_assigned)
  end

  test "trying to assign dock a checked out record results in stale data alert" do
    to = UpdateTO.new(@everything_ap_user, @checked_out, false, params_hash: @phu,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
    assert_stale_alert(@checked_out)
  end

  test "trying to assign dock a voided record results in stale data alert" do
    to = UpdateTO.new(@everything_ap_user, @voided, false, params_hash: @phu,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
    assert_stale_alert(@voided)
  end

  test "a everything ap(disabled) user can't assign dock" do
    to = UpdateTO.new(@everything_ap_user, @record_1, false, params_hash: @phu,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can assign dock" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, true, params_hash: @phu,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't assign dock" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, false, params_hash: @phu,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't assign other company's dock to own record" do
    to = UpdateTO.new(@everything_ap_user, @record_1, false, params_hash: @phu_other,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a everything ap user can't assign dock for other company's record" do
    to = UpdateTO.new(@everything_ap_user, @other_record_1, false, params_hash: @phu_other,
      controller: @controller, form_class: @form)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "user is warned about a deleted/not found record for update" do
    to = UpdateTO.new(@everything_ap_user, @record_1, nil, params_hash: @phu,
      controller: @controller, form_class: @form)
    to.test_nf(self)
  end

end

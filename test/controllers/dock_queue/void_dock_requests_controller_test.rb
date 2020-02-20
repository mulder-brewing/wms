require 'test_helper'

class DockQueue::VoidDockRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @record_1 = dock_queue_dock_requests(:dock_request_1)
    @record_2 = dock_queue_dock_requests(:dock_request_3)
    @other_record_1 = dock_queue_dock_requests(:dock_request_2)
    @dock_assigned = dock_queue_dock_requests(:dock_request_dock_assigned)
    @checked_out = dock_queue_dock_requests(:dock_request_checked_out)
    @voided = dock_queue_dock_requests(:dock_request_voided)

    @dock_group_1 = dock_groups(:cooler)
    @dock_group_2 = dock_groups(:dry)
    @other_dock_group = dock_groups(:other_company)

    @other_admin = auth_users(:other_company_admin)
    @nothing_ap_user = auth_users(:nothing_ap_user)
    @everything_ap_user = auth_users(:everything_ap_user)

    @new = DockQueue::DockRequest.new
    @form = DockQueue::DockRequestForm
    @table = Table::DockQueue::DockRequestsIndexTable
    @controller = "dock_queue/void_dock_requests"

    @ph = { primary_reference: "1", dock_group_id: @dock_group_1.id }
    @phu = {
      primary_reference: "updated",
      phone_number: "(616)211-3697",
      text_message: 1,
      note: "note for update",
      dock_group_id: @dock_group_2.id
    }

    @update_fields = [
      :primary_reference,
      :phone_number,
      :text_message,
      :note,
      :dock_group_id
    ]
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

end

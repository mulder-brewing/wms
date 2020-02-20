require 'test_helper'

class DockRequestsControllerTest < ActionDispatch::IntegrationTest
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
  # Tests link in navbar.

  test "logged out user can't see the link" do
    to = NavbarTO.new(nil, @new, false)
    to.test(self)
  end

  test "nothing ap user can't see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, false)
    to.test(self)
  end

  test "everything ap user can see the link" do
    to = NavbarTO.new(@everything_ap_user, @new, true)
    to.test(self)
  end

  test "everything ap(disabled) user can't see the link" do
    to = NavbarTO.new(@everything_ap_user, @new, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "dock queue ap user can see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, true)
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "dock queue ap(disabled) user can't see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, false)
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for new modal.

  test "logged out user can't get new modal" do
    to = NewTO.new(nil, @new, false)
    to.test(self)
  end

  test "a nothing ap user can't get new modal" do
    to = NewTO.new(@nothing_ap_user, @new, false)
    to.test(self)
  end

  test "new modal title" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.visibles << NewModalTitleVisible.new(model_class: @new.class)
    to.test(self)
  end

  test "new modal buttons" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.visibles << ModalFooterVisible.new(class: Button::ModalSaveButton.class_name)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
    to.test(self)
  end

  test "new modal timestamps aren't visible" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.visibles << ModalTimestampsVisible.new(visible: false)
    to.test(self)
  end

  test "a everything ap user can get new modal" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.test(self)
  end

  test "a everything ap(disabled) user can't get new modal" do
    to = NewTO.new(@everything_ap_user, @new, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can get new modal" do
    to = NewTO.new(@nothing_ap_user, @new, true)
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't get new modal" do
    to = NewTO.new(@nothing_ap_user, @new, false)
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for creating a record.

  test "a logged out user can't create" do
    CreateTO.new(nil, @new, @ph, false).test(self)
  end

  test "a nothing ap user can't create" do
    CreateTO.new(@nothing_ap_user, @new, @ph, false).test(self)
  end

  test "a everything ap user can create" do
    CreateTO.new(@everything_ap_user, @new, @ph, true).test(self)
  end

  test "a everything ap(disabled) user can't create" do
    to = CreateTO.new(@everything_ap_user, @new, @ph, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can create" do
    to = CreateTO.new(@nothing_ap_user, @new, @ph, true)
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't create" do
    to = CreateTO.new(@nothing_ap_user, @new, @ph, false)
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "create fails if there's no dock group id" do
    to = CreateTO.new(@everything_ap_user, @new, @ph.except(:dock_group_id), false)
    to.visibles << FormBaseErrorVisible.new(field: :dock_group_id, type: :exist)
    to.test(self)
  end

  test "create fails if dock group does not belong to company" do
    @ph[:dock_group_id] = @other_dock_group.id
    to = CreateTO.new(@everything_ap_user, @new, @ph, false)
    to.visibles << FormBaseErrorVisible.new(field: :dock_group, type: :does_not_belong)
    to.test(self)
  end

  test "create fails if there's no primary reference" do
    to = CreateTO.new(@everything_ap_user, @new, @ph.except(:primary_reference), false)
    to.visibles << FormFieldErrorVisible.new(field: :primary_reference, type: :blank)
    to.test(self)
  end

  test "create fails if text message is true without a phone number" do
    @ph[:text_message] = 1
    to = CreateTO.new(@everything_ap_user, @new, @ph, false)
    key = "activemodel.errors.models.dock_queue/dock_request.attributes.phone_number.blank_send_sms"
    to.visibles << FormFieldErrorVisible.new(field: :phone_number, error: key)
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for edit modal

  test "logged out user can't get edit modal" do
    EditTO.new(nil, @record_1, false).test(self)
  end

  test "a nothing ap user can't get edit modal" do
    EditTO.new(@nothing_ap_user, @record_1, false).test(self)
  end

  test "edit modal title" do
    to = EditTO.new(@everything_ap_user, @record_1, true)
    to.visibles << EditModalTitleVisible.new(model_class: DockQueue::DockRequest)
    to.test(self)
  end

  test "edit modal buttons" do
    to = EditTO.new(@everything_ap_user, @record_1, true)
    to.visibles << ModalFooterVisible.new(class: Button::ModalSaveButton.class_name)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
    to.test(self)
  end

  test "edit modal timestamps are not visible" do
    to = EditTO.new(@everything_ap_user, @record_1, true)
    to.visibles << ModalTimestampsVisible.new(visible: false)
    to.test(self)
  end

  test "a everything ap user can get the edit modal" do
    EditTO.new(@everything_ap_user, @record_1, true).test(self)
  end

  test "a everything ap(disabled) user can't get the edit modal" do
    to = EditTO.new(@everything_ap_user, @record_1, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can get the edit modal" do
    to = EditTO.new(@nothing_ap_user, @record_1, true)
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't get the edit modal" do
    to = EditTO.new(@nothing_ap_user, @record_1, false)
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't get edit modal for another company" do
    EditTO.new(@everything_ap_user, @other_record_1, false).test(self)
  end

  test "user is warned about a deleted/not found record for edit modal" do
    to = EditTO.new(@everything_ap_user, @record_1, nil)
    to.test_nf(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for updating a record

  test "a logged out user can't update" do
    to = UpdateTO.new(nil, @record_1, @phu, false)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a nothing ap user can't update" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, @phu, false)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a everything ap user can update" do
    to = UpdateTO.new(@everything_ap_user, @record_1, @phu, true)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a everything ap(disabled) user can't update" do
    to = UpdateTO.new(@everything_ap_user, @record_1, @phu, false)
    to.update_fields = @update_fields
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can update" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, @phu, true)
    to.update_fields = @update_fields
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't update" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, @phu, false)
    to.update_fields = @update_fields
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't update other company's record" do
    to = UpdateTO.new(@everything_ap_user, @other_record_1, @phu, false)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "user is warned about a deleted/not found record for update" do
    to = UpdateTO.new(@everything_ap_user, @record_1, @phu, nil)
    to.test_nf(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for showing record

  test "logged out user can't get show modal" do
    ShowTO.new(nil, @record_1, false).test(self)
  end

  test "a nothing ap user can't get show modal" do
    ShowTO.new(@nothing_ap_user, @record_1, false).test(self)
  end

  test "show modal title" do
    to = ShowTO.new(@everything_ap_user, @record_1, true)
    to.visibles << ShowModalTitleVisible.new(model_class: DockQueue::DockRequest)
    to.test(self)
  end

  test "show modal buttons" do
    to = ShowTO.new(@everything_ap_user, @record_1, true)
    to.visibles << ModalFooterVisible.new(class: Button::ModalCloseButton.class_name)
    to.test(self)
  end

  test "show modal timestamps are not visible" do
    to = ShowTO.new(@everything_ap_user, @record_1, true)
    to.visibles << ModalTimestampsVisible.new(visible: false)
    to.test(self)
  end

  test "a everything ap user can get the show modal" do
    ShowTO.new(@everything_ap_user, @record_1, true).test(self)
  end

  test "a everything ap(disabled) user can't get the show modal" do
    to = ShowTO.new(@everything_ap_user, @record_1, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can get the show modal" do
    to = ShowTO.new(@nothing_ap_user, @record_1, true)
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't get the show modal" do
    to = ShowTO.new(@nothing_ap_user, @record_1, false)
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't get show modal for another company" do
    ShowTO.new(@everything_ap_user, @other_record_1, false).test(self)
  end

  test "user is warned about a deleted/not found record for show modal" do
    to = ShowTO.new(@everything_ap_user, @record_1, nil)
    to.test_nf(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for index records

  def query_dg(id)
    { dock_request: { dock_group_id: id } }.to_query
  end

  test "a logged out user can't index" do
    IndexTo.new(nil, @new, false).test(self)
  end

  test "a nothing ap user can't index" do
    IndexTo.new(@nothing_ap_user, @new, false).test(self)
  end

  test "a everything ap(disabled) user can't index" do
    to = IndexTo.new(@everything_ap_user, @new, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can index" do
    to = IndexTo.new(@nothing_ap_user, @new, true)
    to.index_template = Page::DockRequestsPage.render_path
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't index" do
    to = IndexTo.new(@nothing_ap_user, @new, false)
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "page title should be there" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.index_template = Page::DockRequestsPage.render_path
    to.visibles << IndexRecordsTitleVisible.new(model_class: DockQueue::DockRequest)
    to.test(self)
  end

  test "new record button doesn't show if dock group not selected" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.index_template = Page::DockRequestsPage.render_path
    to.visibles << HeaderVisible.new(class: Button::NewButton.class_name, visible: false)
    to.test(self)
  end

  test "new record button shows up if dock group is selected" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.query = query_dg(@dock_group_1.id)
    to.index_template = Page::DockRequestsPage.render_path
    to.visibles << HeaderVisible.new(class: Button::NewButton.class_name)
    to.test(self)
  end

  test "dock group selector only has company dock groups" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.index_template = Page::DockRequestsPage.render_path
    to.visibles << SelectOptionVisible.new(
      id: Page::DockRequestsPage.dg_select_id,
      option_id: @dock_group_1.id,
      visible: true
    )
    to.visibles << SelectOptionVisible.new(
      id: Page::DockRequestsPage.dg_select_id,
      option_id: @dock_group_2.id,
      visible: true
    )
    to.visibles << SelectOptionVisible.new(
      id: Page::DockRequestsPage.dg_select_id,
      option_id: @other_dock_group.id,
      visible: false
    )
    to.test(self)
  end

  test "disabled dock group not in selector" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.index_template = Page::DockRequestsPage.render_path
    @dock_group_1.update_column(:enabled, false)
    to.visibles << SelectOptionVisible.new(
      id: Page::DockRequestsPage.dg_select_id,
      option_id: @dock_group_1.id,
      visible: false
    )
    to.test(self)
  end

  test "only dock requests in selected dock group show up" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.query = query_dg(@dock_group_1.id)
    to.index_template = Page::DockRequestsPage.render_path
    to.visibles << VisibleTO.new(id: @table.row_id(@record_1))
    to.visibles << VisibleTO.new(id: @table.row_id(@record_2), visible: false)
    to.test(self)
  end

  test "dock request from other company does not show up" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.query = query_dg(@dock_group_1.id)
    to.index_template = Page::DockRequestsPage.render_path
    to.visibles << VisibleTO.new(id: @table.row_id(@other_record_1), visible: false)
    to.test(self)
  end

  test "dock request that is dock assigned shows up" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.query = query_dg(@dock_group_1.id)
    to.index_template = Page::DockRequestsPage.render_path
    to.visibles << VisibleTO.new(id: @table.row_id(@dock_assigned))
    to.test(self)
  end

  test "dock request that is checked out does not show up" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.query = query_dg(@dock_group_1.id)
    to.index_template = Page::DockRequestsPage.render_path
    to.visibles << VisibleTO.new(id: @table.row_id(@checked_out), visible: false)
    to.test(self)
  end

  test "dock request that is voided does not show up" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.query = query_dg(@dock_group_1.id)
    to.index_template = Page::DockRequestsPage.render_path
    to.visibles << VisibleTO.new(id: @table.row_id(@voided), visible: false)
    to.test(self)
  end

end

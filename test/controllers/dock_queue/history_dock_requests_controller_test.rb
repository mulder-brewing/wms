require 'test_helper'

class DockQueue::HistoryDockRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @record_1 = dock_queue_dock_requests(:dock_request_1)
    @record_2 = dock_queue_dock_requests(:dock_request_3)
    @other_record_1 = dock_queue_dock_requests(:dock_request_2)

    @other_admin = auth_users(:other_company_admin)
    @nothing_ap_user = auth_users(:nothing_ap_user)
    @everything_ap_user = auth_users(:everything_ap_user)
    @everything_ap_shipper_admin = auth_users(:everything_ap_shipper_company_admin)
    @nothing_ap_shipper_admin = auth_users(:nothing_ap_shipper_company_admin)

    @new = DockQueue::DockRequest.new
    @form = DockGroupForm
    @index_template = Page::HistoryDockRequestsPage.render_path

    @update_fields = [:description, :enabled]

    @ph = { :description => "Default" }
    @phu = { :description => "Updated for test", :enabled => false }

    @path = PathUtil.path("dock_queue_history_dock_requests_path")
  end

  # ----------------------------------------------------------------------------
  # Tests link in navbar.

  test "logged out user can't see the link" do
    to = NavbarTO.new(nil, @new, false, path: @path)
    to.test(self)
  end

  test "nothing ap user can't see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, false, path: @path)
    to.test(self)
  end

  test "everything ap user can see the link" do
    to = NavbarTO.new(@everything_ap_user, @new, true, path: @path)
    to.test(self)
  end

  test "everything ap(disabled) user can't see the link" do
    to = NavbarTO.new(@everything_ap_user, @new, false, path: @path)
    to.disable_user_access_policy
    to.test(self)
  end

  test "dock queue ap user can see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, true, path: @path)
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "dock queue ap(disabled) user can't see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, false, path: @path)
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "everything ap shipper user can't see the link" do
    to = NavbarTO.new(@everything_ap_shipper_admin, @new, false, path: @path)
    to.test(self)
  end

  test "dock queue ap shipper user can't see the link" do
    to = NavbarTO.new(@nothing_ap_shipper_admin, @new, false, path: @path)
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for index records

  test "a logged out user can't index" do
    to = IndexTo.new(nil, @new, false, path: @path)
    to.test(self)
  end

  test "a nothing ap user can't index" do
    to = IndexTo.new(@nothing_ap_user, @new, false, path: @path)
    to.test(self)
  end

  test "a everything ap user can index and only see own records" do
    to = IndexTo.new(@everything_ap_user, @new, true, path: @path)
    to.visibles << IndexTRecordVisible.new(record: @record_1)
    to.visibles << IndexTRecordVisible.new(record: @record_2)
    to.visibles << IndexTRecordVisible.new(record: @other_record_1, visible: false)
    to.test(self)
  end

  test "a everything ap(disabled) user can't index" do
    to = IndexTo.new(@everything_ap_user, @new, false, path: @path)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock queue ap user can index" do
    to = IndexTo.new(@nothing_ap_user, @new, true, path: @path)
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "a dock queue ap(disabled) user can't index" do
    to = IndexTo.new(@nothing_ap_user, @new, false, path: @path)
    to.enable_model_permission("dock_queue")
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap shipper user can't index" do
    IndexTo.new(@everything_ap_shipper_admin, @new, false, path: @path).test(self)
  end

  test "a dock queue ap shipper user can't index" do
    to = IndexTo.new(@nothing_ap_shipper_admin, @new, false, path: @path)
    to.enable_model_permission("dock_queue")
    to.test(self)
  end

  test "page title should be there" do
    to = IndexTo.new(@everything_ap_user, @new, true, path: @path)
    to.visibles << HeaderTitleVisible.new(text: "dock_queue/history_dock_requests.title")
    to.test(self)
  end

  test "page should not have new record button" do
    to = IndexTo.new(@everything_ap_user, @new, true, path: @path)
    to.visibles << HeaderVisible.new(class: Button::NewButton.class_name, visible: false)
    to.test(self)
  end

  test "page should not have enabled filter" do
    to = IndexTo.new(@everything_ap_user, @new, true, path: @path)
    to.visibles << EnabledFilterVisible.new(visible: false)
    to.test(self)
  end

  test "pagination is there" do
    to = IndexTo.new(@everything_ap_user, @new, true, path: @path)
    to.visibles << PaginationVisible.new
    to.test(self)
  end
end

require 'test_helper'
require 'pp'

class DocksControllerTest < ActionDispatch::IntegrationTest
  def setup
    # users
    @nothing_ap_user = users(:nothing_ap_user)
    @everything_ap_user = users(:everything_ap_user)
    @other_admin = users(:other_company_admin)

    # dock groups
    @dock_group_1 = dock_groups(:cooler)
    @dock_group_2 = dock_groups(:dry)
    @other_dock_group = dock_groups(:other_company)

    # docks
    @record_1 = docks(:average_joe_dock)
    @record_2 = docks(:average_joe_dock_2)
    @other_record_1 = docks(:other_dock)

    # new record
    @new = Dock.new

    # used for creating and updating records
    @ph = { number: "new dock", dock_group_id: @dock_group_1.id }
    @phu = { number: "updated number", dock_group_id: @dock_group_2.id, enabled: false }
    @update_fields = [:number, :dock_group_id, :enabled]
  end

  # ----------------------------------------------------------------------------
  # Tests link in navbar.

  test "logged out user can't see the link" do
    to = NavbarTO.new(nil, @new, false)
    to.query = :enabled
    to.test(self)
  end

  test "nothing ap user can't see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, false)
    to.query = :enabled
    to.test(self)
  end

  test "everything ap user can see the link" do
    to = NavbarTO.new(@everything_ap_user, @new, true)
    to.query = :enabled
    to.test(self)
  end

  test "everything ap(disabled) user can't see the link" do
    to = NavbarTO.new(@everything_ap_user, @new, false)
    to.disable_user_access_policy
    to.query = :enabled
    to.test(self)
  end

  test "dock ap user can see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, true)
    to.enable_model_permission
    to.query = :enabled
    to.test(self)
  end

  test "dock ap(disabled) user can't see the link" do
    to = NavbarTO.new(@nothing_ap_user, @new, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.query = :enabled
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
    to.test_title = true
    to.test(self)
  end

  test "new modal buttons" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.add_save_button
    to.add_close_button
    to.test(self)
  end

  test "new modal timestamps aren't visible" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.timestamps_visible = false
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

  test "a dock ap user can get new modal" do
    to = NewTO.new(@nothing_ap_user, @new, true)
    to.enable_model_permission
    to.test(self)
  end

  test "a dock ap(disabled) user can't get new modal" do
    to = NewTO.new(@nothing_ap_user, @new, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "the enable/disable switch should not be visible on the new modal" do
    to = NewTO.new(@everything_ap_user, @new, true)
    input = InputTO.new(@new.form_input_id(:enabled), false)
    to.add_input(input)
    to.test(self)
  end

  test "disabled dock group doesn't show up in selector on new modal" do
    to = NewTO.new(@everything_ap_user, @new, true)
    @dock_group_1.update_column(:enabled, false)
    select = SelectTO.new(@new.form_input_id(:dock_group_id))
    select.add_option(@dock_group_1.description, @dock_group_1.id, false)
    to.add_input(select)
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

  test "a dock ap user can create" do
    to = CreateTO.new(@nothing_ap_user, @new, @ph, true)
    to.enable_model_permission
    to.test(self)
  end

  test "a dock ap(disabled) user can't create" do
    to = CreateTO.new(@nothing_ap_user, @new, @ph, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "Create with other company id will still save with user's company id" do
    to = CreateTO.new(@everything_ap_user, @new, @ph, true)
    to.merge_params_hash({ company_id: @other_admin.company_id })
    to.attributes = { :company_id => @everything_ap_user.company_id }
    to.test(self)
  end

  test "record should be enabled by default when it's created" do
    to = CreateTO.new(@everything_ap_user, @new, @ph, true)
    to.attributes = { :enabled => true }
    to.test(self)
  end

  test "dock number should be unique per dock group" do
    CreateTO.new(@everything_ap_user, @new, @ph, true).test(self)
    to = CreateTO.new(@everything_ap_user, @new, @ph, false)
    to.add_error_to ErrorTO.new(:unique, :number)
    to.test(self)
  end

  test "number can be the same if different dock groups" do
    CreateTO.new(@everything_ap_user, @new, @ph, true).test(self)
    @ph[:dock_group_id] = @dock_group_2.id
    CreateTO.new(@everything_ap_user, @new, @ph, true).test(self)
  end

  test "can't create dock with dock group from another company" do
    to = CreateTO.new(@everything_ap_user, @new, @ph, false)
    @ph[:dock_group_id] = @other_dock_group.id
    to.add_error_to ErrorTO.new(:does_not_belong, :dock_group_id)
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
    to.test_title = true
    to.test(self)
  end

  test "edit modal buttons" do
    to = EditTO.new(@everything_ap_user, @record_1, true)
    to.add_save_button
    to.add_close_button
    to.test(self)
  end

  test "edit modal timestamps are visible" do
    to = EditTO.new(@everything_ap_user, @record_1, true)
    to.timestamps_visible = true
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

  test "a docks ap user can get the edit modal" do
    to = EditTO.new(@nothing_ap_user, @record_1, true)
    to.enable_model_permission
    to.test(self)
  end

  test "a docks ap(disabled) user can't get the edit modal" do
    to = EditTO.new(@nothing_ap_user, @record_1, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't get edit modal for another company" do
    EditTO.new(@everything_ap_user, @other_record_1, false).test(self)
  end

  test "the enable/disable switch should be visible on the edit modal" do
    to = EditTO.new(@everything_ap_user, @record_1, true)
    input = InputTO.new(@record_1.form_input_id(:enabled))
    to.add_input(input)
    to.test(self)
  end

  test "user is warned about a deleted/not found record for edit modal" do
    to = EditTO.new(@everything_ap_user, @record_1, nil)
    to.test_nf(self)
  end

  test "if record's dock group is diabled, it shows up in selector" do
    to = EditTO.new(@everything_ap_user, @record_1, true)
    @record_1.dock_group.update_column(:enabled, false)
    record_1_dg = @record_1.dock_group
    select = SelectTO.new(@record_1.form_input_id(:dock_group_id))
    select.add_option(record_1_dg.description, record_1_dg.id, true)
    to.add_input(select)
    to.test(self)
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

  test "a docks ap user can update" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, @phu, true)
    to.update_fields = @update_fields
    to.enable_model_permission
    to.test(self)
  end

  test "a docks ap(disabled) user can't update" do
    to = UpdateTO.new(@nothing_ap_user, @record_1, @phu, false)
    to.update_fields = @update_fields
    to.enable_model_permission
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
  # Tests for index records

  test "a logged out user can't index" do
    IndexTo.new(nil, @new, false).test(self)
  end

  test "a nothing ap user can't index" do
    IndexTo.new(@nothing_ap_user, @new, false).test(self)
  end

  test "page title should be there" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.test_title = true
    to.test(self)
  end

  test "page should have new record button" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.test_new = true
    to.test(self)
  end

  test "a everything ap user can index and only see own records" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.add_visible_y_record(@record_1)
    to.add_visible_n_record(@other_record_1)
    to.test(self)
  end

  test "a everything ap(disabled) user can't index" do
    to = IndexTo.new(@everything_ap_user, @new, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a docks ap user can index" do
    to = IndexTo.new(@nothing_ap_user, @new, true)
    to.enable_model_permission
    to.test(self)
  end

  test "a docks ap(disabled) user can't index" do
    to = IndexTo.new(@nothing_ap_user, @new, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "should see the edit buttons" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.test_edit = true
    to.add_visible_edit_record(@record_1)
    to.add_visible_edit_record(@record_2)
    to.test(self)
  end

  test "page should have enabled filter" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.test_enabled_filter = true
    to.test(self)
  end

  test "should see both enabled and disabled with all filter." do
    to = IndexTo.new(@everything_ap_user, @new, true)
    @record_2.update_column(:enabled, false)
    to.add_visible_y_record(@record_1)
    to.add_visible_y_record(@record_2)
    to.test(self)
  end

  test "should only see enabled with enabled filter." do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.query = :enabled
    to.add_visible_y_record(@record_1)
    @record_2.update_column(:enabled, false)
    to.add_visible_n_record(@record_2)
    to.test(self)
  end

  test "should only see disabled with disabled filter." do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.query = :disabled
    to.add_visible_n_record(@record_1)
    @record_2.update_column(:enabled, false)
    to.add_visible_y_record(@record_2)
    to.test(self)
  end

  test "pagination is there" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.test_pagination = true
    to.test(self)
  end

end

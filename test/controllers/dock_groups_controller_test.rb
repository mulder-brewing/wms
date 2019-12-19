require 'test_helper'
require 'pp'

class DockGroupsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @cooler_dock_group = dock_groups(:cooler)
    @other_company_dock_group = dock_groups(:other_company)
    @delete_me_dock_group = dock_groups(:delete_me_dock_group)

    @other_admin = users(:other_company_admin)
    @delete_me_admin = users(:delete_me_admin)
    @nothing_ap_user = users(:nothing_ap_user)
    @everything_ap_user = users(:everything_ap_user)

    @other_company_id = @other_admin.company_id

    @new = DockGroup.new

    @update_fields = [:description, :enabled]
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

  test "a everything ap user can get new modal" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.test(self)
  end

  test "a everything ap(disabled) user can't get new modal" do
    to = NewTO.new(@everything_ap_user, @new, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock groups ap user can get new modal" do
    to = NewTO.new(@nothing_ap_user, @new, true)
    to.enable_model_permission
    to.test(self)
  end

  test "a dock groups ap(disabled) user can't get new modal" do
    to = NewTO.new(@nothing_ap_user, @new, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "the enable/disable switch should not be visible on the new modal" do
    to = NewTO.new(@everything_ap_user, @new, true)
    to.test_enabled = true
    to.test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for creating a record.

  ph = { :description => "Default" }

  test "a logged out user can't create" do
    CreateTO.new(nil, @new, ph, false).test(self)
  end

  test "a nothing ap user can't create" do
    CreateTO.new(@nothing_ap_user, @new, ph, false).test(self)
  end

  test "a everything ap user can create" do
    CreateTO.new(@everything_ap_user, @new, ph, true).test(self)
  end

  test "a everything ap(disabled) user can't create" do
    to = CreateTO.new(@everything_ap_user, @new, ph, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock groups ap user can create" do
    to = CreateTO.new(@nothing_ap_user, @new, ph, true)
    to.enable_model_permission
    to.test(self)
  end

  test "a dock groups ap(disabled) user can't create" do
    to = CreateTO.new(@nothing_ap_user, @new, ph, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "Create with other company id will still save with user's company id" do
    to = CreateTO.new(@everything_ap_user, @new, ph, true)
    to.merge_params_hash({ company_id: @other_company_id })
    to.test_company_id = true
    to.test(self)
  end

  test "record should be enabled by default when it's created" do
    to = CreateTO.new(@everything_ap_user, @new, ph, true)
    to.test_enabled_default = true
    to.test(self)
  end

  test "description should be unique per company" do
    CreateTO.new(@everything_ap_user, @new, ph, true).test(self)
    to = CreateTO.new(@everything_ap_user, @new, ph, false)
    to.add_unique_field :description
    to.test(self)
  end

  test "description can be the same for separate companies" do
    CreateTO.new(@everything_ap_user, @new, ph, true).test(self)
    CreateTO.new(@other_admin, @new, ph, true).test(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for edit modal

  test "logged out user can't get edit modal" do
    EditTO.new(nil, @cooler_dock_group, false).test(self)
  end

  test "a nothing ap user can't get edit modal" do
    EditTO.new(@nothing_ap_user, @cooler_dock_group, false).test(self)
  end

  test "a everything ap user can get the edit modal" do
    EditTO.new(@everything_ap_user, @cooler_dock_group, true).test(self)
  end

  test "a everything ap(disabled) user can't get the edit modal" do
    to = EditTO.new(@everything_ap_user, @cooler_dock_group, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock groups ap user can get the edit modal" do
    to = EditTO.new(@nothing_ap_user, @cooler_dock_group, true)
    to.enable_model_permission
    to.test(self)
  end

  test "a dock groups ap(disabled) user can't get the edit modal" do
    to = EditTO.new(@nothing_ap_user, @cooler_dock_group, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't get edit modal for another company" do
    EditTO.new(@everything_ap_user, @other_company_dock_group, false).test(self)
  end

  test "the enable/disable switch should be visible on the edit modal" do
    to = EditTO.new(@everything_ap_user, @cooler_dock_group, true)
    to.test_enabled = true
    to.test(self)
  end

  test "user is warned about a deleted/not found record for edit modal" do
    to = EditTO.new(@delete_me_admin, @delete_me_dock_group, nil)
    to.test_nf(self)
  end

  # ----------------------------------------------------------------------------
  # Tests for updating a record

  phu = { :description => "Updated for test", :enabled => false }

  test "a logged out user can't update" do
    to = UpdateTO.new(nil, @cooler_dock_group, phu, false)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a nothing ap user can't update" do
    to = UpdateTO.new(@nothing_ap_user, @cooler_dock_group, phu, false)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a everything ap user can update" do
    to = UpdateTO.new(@everything_ap_user, @cooler_dock_group, phu, true)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "a everything ap(disabled) user can't update" do
    to = UpdateTO.new(@everything_ap_user, @cooler_dock_group, phu, false)
    to.update_fields = @update_fields
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock groups ap user can update" do
    to = UpdateTO.new(@nothing_ap_user, @cooler_dock_group, phu, true)
    to.update_fields = @update_fields
    to.enable_model_permission
    to.test(self)
  end

  test "a dock groups ap(disabled) user can't update" do
    to = UpdateTO.new(@nothing_ap_user, @cooler_dock_group, phu, false)
    to.update_fields = @update_fields
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

  test "a everything ap user can't update other company's record" do
    to = UpdateTO.new(@everything_ap_user, @other_company_dock_group, phu, false)
    to.update_fields = @update_fields
    to.test(self)
  end

  test "user is warned about a deleted/not found record for update" do
    to = UpdateTO.new(@delete_me_admin, @delete_me_dock_group, phu, nil)
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

  test "a everything ap user can index and only see own records" do
    to = IndexTo.new(@everything_ap_user, @new, true)
    to.add_visible_y_record(@cooler_dock_group)
    to.add_visible_n_record(@other_company_dock_group)
    to.add_visible_n_record(@delete_me_dock_group)
    to.test(self)
  end

  test "a everything ap(disabled) user can't index" do
    to = IndexTo.new(@everything_ap_user, @new, false)
    to.disable_user_access_policy
    to.test(self)
  end

  test "a dock groups ap user can index" do
    to = IndexTo.new(@nothing_ap_user, @new, true)
    to.enable_model_permission
    to.test(self)
  end

  test "a dock groups ap(disabled) user can't index" do
    to = IndexTo.new(@nothing_ap_user, @new, false)
    to.enable_model_permission
    to.disable_user_access_policy
    to.test(self)
  end

end

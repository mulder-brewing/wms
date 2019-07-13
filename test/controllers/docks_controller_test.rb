require 'test_helper'
require 'pp'

class DocksControllerTest < ActionDispatch::IntegrationTest
  def setup
    # users
    @regular_user = users(:regular_user)
    @company_admin = users(:company_admin_user)
    @app_admin = users(:app_admin_user)
    @other_user = users(:other_company_user)
    @other_admin = users(:other_company_admin)
    @delete_me_admin = users(:delete_me_admin)

    #companies
    @company_admin_company = @company_admin.company
    @other_company = @other_user.company

    # dock groups
    @cooler_dock_group = dock_groups(:cooler)
    @other_company_dock_group = dock_groups(:other_company)
    @updated = dock_groups(:updated)

    # docks
    @average_joe_dock = docks(:average_joe_dock)
    @other_dock = docks(:other_dock)
    @delete_me_dock = docks(:delete_me_dock)

    # dock hash
    dock_number = "new dock"
    updated_number = "updated number"
    @dock_hash = { dock: { number: dock_number, dock_group_id: @cooler_dock_group.id } }
    @other_dock_hash = { dock: { number: dock_number, dock_group_id: @other_company_dock_group.id } }
    @update_dock_hash = { dock: { number: updated_number, dock_group_id: @updated.id, enabled: false } }
    @update_dock_hash_other_dg = { dock: { number: updated_number, dock_group_id: @other_company_dock_group.id, enabled: false } }
    @update_dock_array = ["number", "dock_group_id", "enabled"]
  end

  # tests for who can get the new dock modal.
  test "a logged out user should not get the new dock modal" do
    new_object_modal_as(nil, new_dock_path, false)
  end

  test "a regular user should not get the new dock modal" do
    new_object_modal_as(@regular_user, new_dock_path, false)
  end

  test "a company admin can get the new dock modal" do
    new_object_modal_as(@company_admin, new_dock_path, true)
  end

  test "a app admin can get the new dock modal" do
    new_object_modal_as(@app_admin, new_dock_path, true)
  end

  test "the enabled disabled switch shouldn't show up in the new dock group modal" do
    new_object_modal_as(@company_admin, new_dock_path, true)
    assert_no_match /dock_enabled/, @response.body
  end

  # tests for who can create a new dock.
  test "a logged out user should not be able to create a dock" do
    create_object_as(nil, Dock, docks_path, @dock_hash, false)
  end

  test "a regular user should not be able to create a dock" do
    create_object_as(@regular_user, Dock, docks_path, @dock_hash, false)
  end

  test "a company admin should be able to create a dock" do
    create_object_as(@company_admin, Dock, docks_path, @dock_hash, true)
  end

  test "a app admin should be able to create a dock" do
    create_object_as(@app_admin, Dock, docks_path, @dock_hash, true)
  end

  test "a user should not be able to create a dock in another company" do
    hash_other_company = { company_id: @other_company.id }
    dock_hash_other_company = @dock_hash.merge(hash_other_company)
    create_object_as(@company_admin, Dock, docks_path, @dock_hash, true)
    assert_equal @company_admin_company.id, Dock.last.company_id
  end

  test "a dock should be enabled by default when it's created" do
    create_object_as(@company_admin, Dock, docks_path, @dock_hash, true)
    assert_equal true, Dock.last.enabled
  end

  test "dock number should be unique per dock group" do
    create_object_as(@company_admin, Dock, docks_path, @dock_hash, true)
    create_object_as(@company_admin, Dock, docks_path, @dock_hash, false)
    assert_match /Number has already been taken/, @response.body
  end

  test "dock group description can be the same for separate companies" do
    create_object_as(@company_admin, Dock, docks_path, @dock_hash, true)
    create_object_as(@other_admin, Dock, docks_path, @other_dock_hash, true)
  end

  test "a company admin cannot create a dock for a dock group in another company" do
    create_object_as(@company_admin, Dock, docks_path, @other_dock_hash, false)
    assert_match /Dock group does not belong to your company/, @response.body
  end

  # tests for who can get the show dock modal
  test "a logged out or regular user should not be able to get the show dock modal" do
    show_object_as(nil, dock_path(@average_joe_dock), false)
    show_object_as(@regular_user, dock_path(@average_joe_dock), false)
  end

  test "a company admin or app admin should be able to get the show dock modal" do
    show_object_as(@company_admin, dock_path(@average_joe_dock), true)
    show_object_as(@app_admin, dock_path(@average_joe_dock), true)
  end

  test "a company_admin or app admin shouldn't be able to see a dock from another company" do
    show_object_as(@company_admin, dock_path(@other_dock), false)
    show_object_as(@app_admin, dock_path(@other_dock), false)
  end

  # tests for who can get the edit dock modal.
  test "a logged out or regular user should not be able to get the edit dock modal" do
    edit_object_as(nil, edit_dock_path(@average_joe_dock), true, false)
    edit_object_as(@regular_user, edit_dock_path(@average_joe_dock), true, false)
  end

  test "a company or app admin should be able to get the edit dock modal" do
    edit_object_as(@company_admin, edit_dock_path(@average_joe_dock), false, true)
    edit_object_as(@app_admin, edit_dock_path(@average_joe_dock), false, true)
  end

  test "a company or app admin should not be able to get edit dock modal for another company's dock" do
    edit_object_as(@company_admin, edit_dock_path(@other_dock), true, false)
    edit_object_as(@app_admin, edit_dock_path(@other_dock), true, false)
  end

  test "the enable/disable switch should be visible on the edit modal" do
    edit_object_as(@company_admin, edit_dock_path(@average_joe_dock), false, true)
    assert_match /dock_enabled/, @response.body
  end

  # tests for who can update a dock.
  test "a logged out or regular user should not be able to update a dock" do
    update_object_as(nil, @average_joe_dock ,dock_path(@average_joe_dock), @update_dock_hash, @update_dock_array, false)
    update_object_as(@regular_user, @average_joe_dock ,dock_path(@average_joe_dock), @update_dock_hash, @update_dock_array, false)
  end

  test "a company admin should be able to update a dock" do
    update_object_as(@company_admin, @average_joe_dock ,dock_path(@average_joe_dock), @update_dock_hash, @update_dock_array, true)
  end

  test "a app admin should be able to update a dock" do
    update_object_as(@app_admin, @average_joe_dock ,dock_path(@average_joe_dock), @update_dock_hash, @update_dock_array, true)
  end

  test "a company admin or app admin should not be able to update a dock from another company" do
    update_object_as(@company_admin, @other_dock ,dock_path(@other_dock), @update_dock_hash, @update_dock_array, false)
  end

  test "a company admin shouldn't be able to update a dock from another company even if the dock group is right for the other company" do
    update_object_as(@company_admin, @other_dock ,dock_path(@other_dock), @update_dock_hash_other_dg, @update_dock_array, false)
  end

  # tests for who can get the index of docks.
  test "a logged out or regular user should not be able to get the index of docks" do
    index_objects(nil, docks_path, "docks/index", false)
    index_objects(@regular_user, docks_path, "docks/index", false)
  end

  test "a company or app admin should be able to get the index of docks" do
    index_objects(@company_admin, docks_path, "docks/index", true)
    index_objects(@app_admin, docks_path, "docks/index", true)
    # should see this dock from own company
    assert_select "tr#dock_#{@average_joe_dock.id}"
    # shouldn't see this dock from another company.
    assert_select "tr#dock_#{@other_dock.id}", false
  end

  # tests notification of a stale dock no longer existing because it was delteted.
  test "if a dock group is deleted and a user trys to show, edit, or update it, they are warned the dock group no longer exists." do
    paths = { show: dock_path(@delete_me_dock), update: dock_path(@delete_me_dock), edit: edit_dock_path(@delete_me_dock) }
    hash = { dock: { number: "updated dock" } }
    text = "Dock no longer exists"
    check_if_object_deleted(@delete_me_admin, paths, hash, text, false)
    @delete_me_dock.destroy
    check_if_object_deleted(@delete_me_admin, paths, hash, text, true)
  end

end

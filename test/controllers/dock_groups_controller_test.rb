require 'test_helper'
require 'pp'

class DockGroupsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @cooler_dock_group = dock_groups(:cooler)
    @other_company_dock_group = dock_groups(:other_company)
    @regular_user = users(:regular_user)
    @company_admin = users(:company_admin_user)
    @app_admin = users(:app_admin_user)
    @other_user = users(:other_company_user)
    @other_admin = users(:other_company_admin)
    @company_admin_company = @company_admin.company
    @other_company = @other_user.company
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to getting new dock group page/modal.
  def new_dock_group_modal(user, validity)
    log_in_if_user(user)
    get new_dock_group_path, xhr:true
    assert_equal validity, !redirected?(@response)
  end

  test "logged out user can't get new dock group modal" do
    new_dock_group_modal(nil, false)
  end

  test "a regular user can't get new dock group modal" do
    new_dock_group_modal(@regular_user, false)
  end

  test "a company admin can get new dock group modal" do
    new_dock_group_modal(@company_admin, true)
  end

  test "a app admin can get new dock group modal" do
    new_dock_group_modal(@app_admin, true)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # These functions helps all the following tests to run related to creating a dock group.
  def set_params(parameters)
    return { dock_group: parameters }
  end

  def post_dock_group(params)
    post dock_groups_path, xhr: true, params: params
  end

  def create_dock_group_as(user, parameters, validity)
    log_in_if_user(user)
    params = set_params(parameters)
    if validity == false
      assert_no_difference 'DockGroup.count' do
        post_dock_group(params)
      end
    else
      assert_difference 'DockGroup.count', 1 do
        post_dock_group(params)
      end
    end
  end

  def create_and_return_dock_group(user, parameters)
    log_in_if_user(user)
    params = set_params(parameters)
    post_dock_group(params)
    return DockGroup.last
  end

  default_description = "Default"
  dock_group_hash = { description: default_description }

  test "a logged out user should not be able to create a dock group" do
    create_dock_group_as(nil, dock_group_hash, false)
  end

  test "a regular user shouldn't be able to create a dock group" do
    create_dock_group_as(@regular_user, dock_group_hash, false)
  end

  test "a company admin should be able to create a dock group" do
    create_dock_group_as(@company_admin, dock_group_hash, true)
  end

  test "a app admin should be able to create a dock group" do
    create_dock_group_as(@company_admin, dock_group_hash, true)
  end

  test "a user should not be able to create a dock group in another company" do
    hash_other_company = { company_id: @other_company.id }
    dock_group_hash_other_company = dock_group_hash.merge(hash_other_company)
    dock_group = create_and_return_dock_group(@company_admin, dock_group_hash_other_company)
    assert_equal @company_admin_company.id, dock_group.company_id
  end

  test "a dock group should be enabled by default when it's created" do
    dock_group = create_and_return_dock_group(@company_admin, dock_group_hash)
    assert_equal true, dock_group.enabled
  end

  test "dock group description should be unique per company" do
    create_dock_group_as(@company_admin, dock_group_hash, true)
    create_dock_group_as(@company_admin, dock_group_hash, false)
    assert_match /Description has already been taken/, @response.body
  end

  test "dock group description can be the same for separate companies" do
    create_dock_group_as(@company_admin, dock_group_hash, true)
    create_dock_group_as(@other_admin, dock_group_hash, true)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to getting the show dock group modal.
  def show_dock_group_as(user, dock_group, validity)
    log_in_if_user(user)
    get dock_group_path(dock_group), xhr:true
    assert_equal validity, !redirected?(@response)
  end

  test "logged out user or regular user should not get show dock group model" do
    show_dock_group_as(nil, @cooler_dock_group, false)
    show_dock_group_as(@regular_user, @cooler_dock_group, false)
  end

  test "a company admin or app admin should get show dock group modal" do
    show_dock_group_as(@company_admin, @cooler_dock_group, true)
    show_dock_group_as(@app_admin, @cooler_dock_group, true)
  end

  test "a company_admin shouldn't be able to see a dock group from another company" do
    show_dock_group_as(@company_admin, @other_company_dock_group, false)
  end
end

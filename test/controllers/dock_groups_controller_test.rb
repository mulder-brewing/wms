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
    @dock_groups_ap_user = users(:dock_groups_ap_user)
    @everything_ap_user = users(:everything_ap_user)

    @new = DockGroup.new
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
    to = NewTO.new(nil, @new, false)
    new_to_test(to)
  end

  test "a nothing ap user can't get new dock group modal" do
    new_dock_group_modal(@nothing_ap_user, false)
  end

  test "a everything ap user can get new dock group modal" do
    new_dock_group_modal(@everything_ap_user, true)
  end

  test "a dock groups ap user can get new dock group modal" do
    new_dock_group_modal(@dock_groups_ap_user, true)
  end

  test "the enabled disabled switch shouldn't show up in the new dock group modal" do
    new_dock_group_modal(@everything_ap_user, true)
    assert_no_match /dock_group_enabled/, @response.body
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

  test "a nothing ap user shouldn't be able to create a dock group" do
    create_dock_group_as(@nothing_ap_user, dock_group_hash, false)
  end

  test "a everything ap user should be able to create a dock group" do
    create_dock_group_as(@everything_ap_user, dock_group_hash, true)
  end

  test "a dock groups ap user should be able to create a dock group" do
    create_dock_group_as(@dock_groups_ap_user, dock_group_hash, true)
  end

  test "a user should not be able to create a dock group in another company" do
    hash_other_company = { company_id: @other_company_dock_group.company_id }
    dock_group_hash_other_company = dock_group_hash.merge(hash_other_company)
    dock_group = create_and_return_dock_group(@everything_ap_user, dock_group_hash_other_company)
    assert_equal @everything_ap_user.company_id, dock_group.company_id
  end

  test "a dock group should be enabled by default when it's created" do
    dock_group = create_and_return_dock_group(@everything_ap_user, dock_group_hash)
    assert_equal true, dock_group.enabled
  end

  test "dock group description should be unique per company" do
    create_dock_group_as(@everything_ap_user, dock_group_hash, true)
    create_dock_group_as(@everything_ap_user, dock_group_hash, false)
    assert_match /Description has already been taken/, @response.body
  end

  test "dock group description can be the same for separate companies" do
    create_dock_group_as(@everything_ap_user, dock_group_hash, true)
    create_dock_group_as(@other_admin, dock_group_hash, true)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to getting the edit dock_group modal.
  def edit_dock_group_as(user, dock_group, validity, switch = nil)
    log_in_if_user(user)
    get edit_dock_group_path(dock_group), xhr:true
    assert_equal validity, !redirected?(@response)
  end

  test "logged out user or regular user should not get edit dock group modal" do
    edit_dock_group_as(nil, @cooler_dock_group, false)
  end

  test "a nothing ap user should not be able to get the edit dock group modal" do
    edit_dock_group_as(@nothing_ap_user, @cooler_dock_group, false)
  end

  test "a everything ap user should be able to get the edit dock group modal" do
    edit_dock_group_as(@everything_ap_user, @cooler_dock_group, true)
  end

  test "a dock groups ap user should be able to get the edit dock group modal" do
    edit_dock_group_as(@dock_groups_ap_user, @cooler_dock_group, true)
  end

  test "a everything ap user should not be able to get edit dock group modal for another company's dock group" do
    edit_dock_group_as(@everything_ap_user, @other_company_dock_group, false)
  end

  test "the enable/disable switch should be visible on the edit modal" do
    edit_dock_group_as(@everything_ap_user, @cooler_dock_group, true)
    assert_match /dock_group_enabled/, @response.body
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to updating dock groups.
  def update_dock_group_as(user, dock_group, parameter, validity)
    params = { dock_group: parameter }
    log_in_if_user(user)
    patch dock_group_path(dock_group), xhr: true, params: params
    dock_group.reload
    expected_description = parameter[:description]
    expected_enabled = parameter[:enabled]
    actual_description = dock_group.description
    actual_enabled = dock_group.enabled
    if validity == true
      assert_equal expected_description, actual_description
      assert_equal expected_enabled, actual_enabled
    else
      assert_not_equal expected_description, actual_description
      assert_not_equal expected_enabled, actual_enabled
    end
  end

  update_description_hash = { description: "Updated for test", enabled: false}

  test "a logged out user or regular should not be able to update a dock group" do
    update_dock_group_as(nil, @cooler_dock_group, update_description_hash, false)
  end

  test "a nothing ap user should not be able to update a dock group" do
    update_dock_group_as(@nothing_ap_user, @cooler_dock_group, update_description_hash, false)
  end

  test "a everything_ap_user should be able to update a dock group" do
    update_dock_group_as(@everything_ap_user, @cooler_dock_group, update_description_hash, true)
  end

  test "a dock groups ap user should be able to update a dock group" do
    update_dock_group_as(@dock_groups_ap_user, @cooler_dock_group, update_description_hash, true)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to index of dock groups.
  def index_dock_groups(user, validity)
    log_in_if_user(user)
    get dock_groups_path
    if validity == true
      assert_template Page::IndexListPage::INDEX_HTML_PATH
    else
      assert_redirected_to root_url
    end
  end

  test "a logged out user should not get the dock groups index page" do
    index_dock_groups(nil, false)
  end

  test "a nothing ap user should not be able to get the dock groups index page" do
    index_dock_groups(@nothing_ap_user, false)
  end

  test "a everything ap user should get the dock groups index page and should only dock groups from own company." do
    index_dock_groups(@everything_ap_user, true)
    # should see this dock group from own company
    assert_select "tr##{@cooler_dock_group.table_row_id}"
    # shouldn't see this dock group from another company.
    assert_select "tr##{@other_company_dock_group.table_row_id}", false
  end

  test "a dock groups ap user should be able to get the dock groups index page." do
    index_dock_groups(@dock_groups_ap_user, true)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # tests for deleted dock group alerts on show, edit, update.

  def check_if_dock_group_deleted(user, dock_group_to_test, try, validity)
    log_in_if_user(user)
    case try
      when "update"
        patch dock_group_path(dock_group_to_test), xhr: true, params: { dock_group: { description: "updated dock group" } }
      when "edit"
        get edit_dock_group_path(dock_group_to_test), xhr:true
    end
    if validity == true
      assert_equal true, not_found?(@response)
    else
      assert_equal false, not_found?(@response)
    end
  end

  test "if a dock group is deleted and a user trys to edit, or update it, they are warned the dock group no longer exists." do
    check_if_dock_group_deleted(@delete_me_admin, @delete_me_dock_group, "update", false)
    check_if_dock_group_deleted(@delete_me_admin, @delete_me_dock_group, "edit", false)
    @delete_me_dock_group.destroy
    check_if_dock_group_deleted(@delete_me_admin, @delete_me_dock_group, "update", true)
    check_if_dock_group_deleted(@delete_me_admin, @delete_me_dock_group, "edit", true)
  end

end

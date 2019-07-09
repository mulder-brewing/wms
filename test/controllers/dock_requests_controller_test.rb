require 'test_helper'
require 'pp'

class DockRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    # users
      # These users belong to averagejoes company
      @regular_user = users(:regular_user)
      @company_admin = users(:company_admin_user)
      @app_admin = users(:app_admin_user)
      # These users belong to other_company
      @other_user = users(:other_company_user)
      @other_admin = users(:other_company_admin)
      # This user belongs to company_to_delete
      @delete_me_admin = users(:delete_me_admin)
      # These users belong to nothing_setup_company
      @nothing_setup_company_user = users(:nothing_setup_company_user)
      @nothing_setup_company_admin = users(:nothing_setup_company_admin)

    # dock groups
      #this dock group belongs to other company
      @other_company_dg = dock_groups(:other_company)
      # these dock groups belong to averagejoes company
      @cooler = dock_groups(:cooler)
      @dry = dock_groups(:dry)
      @updated = dock_groups(:updated)

    # docks
      # This dock belongs to other_company
      @other_dock = docks(:other_dock)
      # This dock belongs to averagejoes company
      @average_joe_dock = docks(:average_joe_dock)

    # dock_requests
      # These dock requests belongs to averagejoes company
      @dock_request_1 = dock_requests(:dock_request_1)
      @dock_request_3 = dock_requests(:dock_request_3)
      # This dock request belongs to other company
      @dock_request_2 = dock_requests(:dock_request_2)

    # hashes
      # dock request hash
      test_reference = "test123"
      @dock_request_hash = { dock_request: { primary_reference: test_reference, phone_number: "2122123636", text_message: false, note: "This is my note!" } }
      @dock_request_with_dock_hash = { dock_request: { primary_reference: test_reference, dock_id: @average_joe_dock.id } }
      @dock_request_update_hash = { dock_request: { primary_reference: "updated", phone_number: "0002223547", text_message: true, note: "I have been updated" } }
      @update_dock_request_array = ["primary_reference", "phone_number", "text_message", "note"]
  end

  # This function will get the dock requests index page if boolean is true, this can set the current dock group if there's only one that's enabled.
  def get_index
    get dock_requests_path
  end

  # This function will get the dock requests index page with a certain dock group (if that dock group isn't nil).  This sets current dock group if there's more than one that's enabled.
  def get_index_with(dock_group)
    get dock_requests_path(dock_request: { dock_group_id: dock_group.id }) if !dock_group.nil?
  end

  # When there is only one enabled dock group, for the index page, the user is redirected to the URL for that dock group automatically.  Tests need to follow this redirect when that's the case.
  def follow_redirect_if_necessary(user)
    if !user.nil?
      enabled_dock_groups_number = DockGroup.enabled_where_company(user.company_id).length
      follow_redirect! if enabled_dock_groups_number == 1
    end
  end

  # This function just combines two functions for the sake of convenience.
  def get_index_page_redirect_if_necessary(get_index_page, user)
    if get_index_page
      get_index
      follow_redirect_if_necessary(user)
    end
  end


  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to checking the index page errors.
  def check_index_page_errors(user, error_message_regex, validity)
    log_in_if_user(user)
    get_index_page_redirect_if_necessary(true, user)
    new_path = "/dock_requests/new"
    if validity == true
      assert_match error_message_regex, @response.body
      assert_select "a[href=?]", new_path, false
    else
      assert_no_match error_message_regex, @response.body
      assert_select "a[href=?]", new_path
    end
  end

  error_message_no_enabled_dock_groups = /You need at least one enabled dock group before you can use the dock queue/
  error_message_no_enabled_docks = /You need at least one enabled dock in this dock group before you can create a new check-in/

  test "a company with no dock groups should get a error message and not have a link to create a new dock request" do
    check_index_page_errors(@nothing_setup_company_user, error_message_no_enabled_dock_groups, true)
  end

  test "a company with at least one enabled dock group shouldn't get a error message and should have a link to create a new dock request" do
    check_index_page_errors(@other_user, error_message_no_enabled_dock_groups, false)
  end

  test "a company with only disabled dock groups should get a error message and not have a link to create a new dock request" do
    @other_company_dg.update_attribute(:enabled, false)
    check_index_page_errors(@other_user, error_message_no_enabled_dock_groups, true)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to checking the index page for the dock group selector.
  def check_index_page_for_group_selector(user, validity)
    new_path = "/dock_requests/new"
    log_in_if_user(user)
    get_index_page_redirect_if_necessary(true, user)
    if validity == true
      assert_select "form"
      assert_select "form select[id=dock_group_select]"
      enabled_dock_groups = DockGroup.enabled_where_company(user.company_id)
      enabled_dock_groups.each do |dock_group|
        assert_select "form select[id=dock_group_select] option[value=#{dock_group.id}]"
      end
      disabled_dock_groups = DockGroup.disabled_where_company(user.company_id)
      disabled_dock_groups.each do |dock_group|
        assert_select "form select[id=dock_group_select] option[value=#{dock_group.id}]", false
      end
      assert_select "a[href=?]", new_path, false
    else
      assert_select "form", false
    end
  end

  test "a company with more than one enabled dock group should get the dock group selector and only enabled dock groups should be in the selector.  Also shouldn't have new link." do
    @cooler.update_attribute(:enabled, false)
    check_index_page_for_group_selector(@regular_user, true)
  end

  test "a company with only one enabled dock group shouldn't get the dock group selector" do
    check_index_page_for_group_selector(@other_user, false)
  end

  test "a company with no dock groups shouldn't get the dock group selector" do
    check_index_page_for_group_selector(@nothing_setup_company_user, false)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # This function helps all the following tests to run related to getting new dock request modal.
  def new_dock_request_modal(user, get_index_page, dock_group, validity)
    log_in_if_user(user)
    get_index_page_redirect_if_necessary(get_index_page, user)
    get dock_requests_path(dock_request: { dock_group_id: dock_group.id }) if !dock_group.nil?
    get new_dock_request_path, xhr:true
    if validity == true
      assert_select "form"
      assert_match /create-modal/, @response.body
      assert_match /dock_request_primary_reference/, @response.body
    else
      assert_match /No dock group selected/, @response.body
    end
  end

  # a logged out user should be redirected.
  test "a logged out user should not get the new dock request modal" do
    new_object_modal_as(nil, new_dock_request_path, false)
  end

  test "a logged in user with no dock groups shouldn't get the new dock request modal" do
    new_dock_request_modal(@nothing_setup_company_user, true, nil, false)
  end

  test "a logged in user that hasn't set a dock group yet should not get the new dock request modal" do
    new_dock_request_modal(@other_user, false, nil, false)
  end

  test "a logged in user that visits the index page (1 dock group THAT IS DISABLED) should not get the new dock request modal" do
    @other_company_dg.update_attribute(:enabled, false)
    new_dock_request_modal(@other_user, true, nil, false)
  end

  test "a logged in user that visits the index page (1 dock group) should get the new dock request modal" do
    new_dock_request_modal(@other_user, true, nil, true)

  end

  test "a logged in user that visits the index page (3 dock groups) should not get the new dock request modal because dock group needs selecting first" do
    new_dock_request_modal(@regular_user, true, nil, false)
  end

  test "a logged in user that visits the index page (3 dock groups) and selects a dock group should get the new dock request modal" do
    new_dock_request_modal(@regular_user, true, @cooler, true)
  end

  # ----------------------------------------------------------------------------
  # ----------------------------------------------------------------------------
  # These functions helps all the following tests to run related to creating a dock request
  def create_dock_request_as(user, params, get_index_page, dock_group, validity)
    log_in_if_user(user)
    get_index_page_redirect_if_necessary(get_index_page, user)
    get_index_with(dock_group)
    params[:dock_request][:dock_group_id] = dock_group.id if !dock_group.nil?
    if validity == true
      assert_difference 'DockRequest.count', 1 do
        post dock_requests_path, xhr: true, params: params
      end
    else
      assert_no_difference 'DockRequest.count' do
        post dock_requests_path, xhr: true, params: params
      end
    end
  end

  # tests for who can create a new dock.
  test "a logged out user should not be able to create a dock request" do
    create_dock_request_as(nil, @dock_request_hash, true, nil, false)
  end

  test "a logged in user with no dock groups shouldn't be able to create a dock request" do
    create_dock_request_as(@nothing_setup_company_user, @dock_request_hash, true, nil, false)
    assert_match /Dock group must exist/, @response.body
  end

  test "a logged in user (1 dock group) should be able to create a dock request" do
    create_dock_request_as(@other_user, @dock_request_hash, false, @other_company_dg, true)
  end

  test "a logged in user (1 DISABLED dock group) shouldn't be able to create a dock request" do
    @other_company_dg.update_attribute(:enabled, false)
    create_dock_request_as(@other_user, @dock_request_hash, false, @other_company_dg, false)
    assert_match /Dock group #{@other_company_dg.description} is disabled/, @response.body
  end

  test "a logged in user (3 dock groups) shuldn't be able to create a dock request without selecting a dock group." do
    create_dock_request_as(@regular_user, @dock_request_hash, true, nil, false)
    assert_match /Dock group must exist/, @response.body
  end

  test "a logged in user (3 dock groups) should be able to create a dock request if a dock group is selected first" do
    create_dock_request_as(@regular_user, @dock_request_hash, true, @cooler, true)
  end

  test "trying to create a dock request with a dock assignment should succeed but the dock_id should still be nil" do
    create_dock_request_as(@regular_user, @dock_request_with_dock_hash, true, @cooler, true)
    created_dock = DockRequest.last
    assert_nil created_dock.dock_id
  end

  test "trying to create a dock request where the company id of the dock group doesn't match the company id of the dock request should fail" do
    create_dock_request_as(@regular_user, @dock_request_hash, true, @other_company_dg, false)
    assert_match /Dock group does not belong to your company/, @response.body
  end

  # tests for who can get the show dock request modal
  test "a logged out user should not be able to get the show dock request modal" do
    show_object_as(nil, dock_request_path(@dock_request_1), false)
  end

  test "a logged in user should be able to get the show dock request modal" do
    show_object_as(@regular_user, dock_request_path(@dock_request_1), true)
  end

  test "a logged in user should not be able to get the show dock request modal for another company's dock request" do
    show_object_as(@other_user, dock_request_path(@dock_request_1), false)
  end

  # tests for who can get the edit dock request modal.
  test "a logged out user should not be able to get the edit dock request modal" do
    edit_object_as(nil, edit_dock_request_path(@dock_request_1), false)
  end

  test "a logged in user should be able to get the edit dock request modal" do
    edit_object_as(@regular_user, edit_dock_request_path(@dock_request_1), true)
  end

  test "a logged in user should not be able to get the edit dock request modal for another company's dock request" do
    edit_object_as(@other_user, edit_dock_request_path(@dock_request_1), false)
  end

  # tests for who can update a dock request.
  test "a logged out user should not be able to update a dock request" do
    update_object_as(nil, @dock_request_1 ,dock_request_path(@dock_request_1), @dock_request_update_hash, @update_dock_request_array, false)
  end

  test "a logged in user should be able to update a dock request" do
    update_object_as(@regular_user, @dock_request_1 ,dock_request_path(@dock_request_1), @dock_request_update_hash, @update_dock_request_array, true)
  end

  test "a logged in suer should not be able to update another company's dock request" do
    update_object_as(@other_user, @dock_request_1 ,dock_request_path(@dock_request_1), @dock_request_update_hash, @update_dock_request_array, false)
  end

  # tests for who can get the index of dock requests.
  test "a logged out user should not be able to get the index of dock requests" do
    index_objects(nil, dock_requests_path, "dock_requests/index", false)
  end

  test "a logged in user should be able to get the index of dock requests" do
    index_objects(@other_user, dock_requests_path(dock_request: { dock_group_id: @other_company_dg.id }), "dock_requests/index", true)
    # should see this dock request from own company
    assert_select "div#dock_request_#{@dock_request_2.id}"
    # shouldn't see this dock request from another company.
    assert_select "div#dock_request_#{@dock_request_1.id}", false
  end

  test "a logged in user should not be able to get index of dock requests for a dock group that doesn't belong to own company" do
    log_in_if_user(@regular_user)
    get_index_with(@other_company_dg)
    assert redirected?(@response)
  end

  test "a logged in user with more than one dock group should see dock requests only in their respective groups" do
    index_objects(@regular_user, dock_requests_path(dock_request: { dock_group_id: @cooler.id }), "dock_requests/index", true)
    # should see this dock request from cooler dock group
    assert_select "div#dock_request_#{@dock_request_1.id}"
    # shouldn't see this dock request dry dock group.
    assert_select "div#dock_request_#{@dock_request_3.id}", false
    # shouldn't see this dock request from another company.
    assert_select "div#dock_request_#{@dock_request_2.id}", false
    index_objects(@regular_user, dock_requests_path(dock_request: { dock_group_id: @dry.id }), "dock_requests/index", true)
    # should see this dock request from dry dock group
    assert_select "div#dock_request_#{@dock_request_3.id}"
    # shouldn't see this dock request cooler dock group.
    assert_select "div#dock_request_#{@dock_request_1.id}", false
    # shouldn't see this dock request from another company.
    assert_select "div#dock_request_#{@dock_request_2.id}", false
  end


















end

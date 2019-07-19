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
      @update_dock = docks(:update_dock)

    # dock_requests
      # These dock requests belongs to averagejoes company
      @dock_request_1 = dock_requests(:dock_request_1)
      @dock_request_3 = dock_requests(:dock_request_3)
      @dock_request_dock_assigned = dock_requests(:dock_request_dock_assigned)
      @dock_request_checked_out = dock_requests(:dock_request_checked_out)
      @dock_request_voided = dock_requests(:dock_request_voided)
      @dock_request_no_docks = dock_requests(:dock_request_no_docks)
      # This dock request belongs to other company
      @dock_request_2 = dock_requests(:dock_request_2)
      # This dock request eblongs to the company_to_delete
      @delete_me_dock_request = dock_requests(:delete_me_dock_request)

    # hashes
      # dock request hash
      test_reference = "test123"
      @dock_request_hash = { dock_request: { primary_reference: test_reference, phone_number: "2122123636", text_message: false, note: "This is my note!" } }
      @dock_request_with_dock_hash = { dock_request: { primary_reference: test_reference, dock_id: @update_dock.id } }
      @dock_request_with_dock_and_send_text_message = { dock_request: { dock_id: @update_dock.id, text_message: true } }
      @dock_request_update_hash = { dock_request: { primary_reference: "updated", phone_number: "0002223547", text_message: true, note: "I have been updated" } }
      @update_dock_request_array = ["primary_reference", "phone_number", "text_message", "note"]
      @dock_assign_unassign_array = ["status", "dock_id", "dock_assigned_at"]
      @void_array = ["status", "voided_at"]
      @check_out_array = ["status", "checked_out_at"]

    # error message types
      @danger = 'danger'

    # error messages
      @voided = DockRequest.voided_alert_message
      @checked_out = DockRequest.checked_out_alert_message
      @already_assigned = DockRequest.dock_assigned_alert_message
      @no_longer_dock_assigned = DockRequest.dock_unassigned_alert_message
      @no_enabled_docks = DockRequest.no_enabled_docks_to_assign_alert_message
      @not_checked_in = DockRequest.status_error_no_longer_checked_in
      @checked_out_or_voided = DockRequest.status_error_checked_out_or_voided


    # strings and regex for matching
      @dock_request_voided_remove = "remove('#dock_request_#{@dock_request_voided.id}')"
      @dock_request_checked_out_remove = "remove('#dock_request_#{@dock_request_checked_out.id}')"
      @dock_request_dock_assigned_replace = "$('#dock_request_#{@dock_request_dock_assigned.id}').replaceWith"
      @dock_request_1_replace = "$('#dock_request_#{@dock_request_1.id}').replaceWith"
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

  # This function helps test whether or not a audit history entry was added and if so, verify the details.
  def verify_audit_history_entry(hash_to_verify)
    audit_entry = DockRequestAuditHistory.last
    hash_to_verify.each do |key, value|
      if value.nil?
        assert_nil audit_entry.send(key.to_s)
      else
        assert_equal value, audit_entry.send(key.to_s)
      end
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

  # tests for who can create a new dock request.
  test "a logged out user should not be able to create a dock request" do
    create_dock_request_as(nil, @dock_request_hash, true, nil, false)
  end

  test "a logged in user with no dock groups shouldn't be able to create a dock request" do
    create_dock_request_as(@nothing_setup_company_user, @dock_request_hash, true, nil, false)
    assert_match /Dock group must exist/, @response.body
  end

  test "a logged in user (1 dock group) should be able to create a dock request.  Also it should get logged in the audit history." do
    assert_difference 'DockRequestAuditHistory.count', 1 do
      create_dock_request_as(@other_user, @dock_request_hash, false, @other_company_dg, true)
    end
    created_dock_request_id = DockRequest.last.id
    verify_audit_history_entry({ :event => "checked_in", :user_id => @other_user.id, :company_id => @other_user.company_id, :dock_request_id => created_dock_request_id, :dock_id => nil, :phone_number => nil })
  end

  test "a logged in user (1 DISABLED dock group) shouldn't be able to create a dock request.  Also it should not get logged in the audit history." do
    @other_company_dg.update_attribute(:enabled, false)
    assert_no_difference 'DockRequestAuditHistory.count' do
      create_dock_request_as(@other_user, @dock_request_hash, false, @other_company_dg, false)
    end
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
    edit_object_as(nil, edit_dock_request_path(@dock_request_1), true, false)
  end

  test "a logged in user should be able to get the edit dock request modal" do
    edit_object_as(@regular_user, edit_dock_request_path(@dock_request_1), false, true)
  end

  test "a logged in user should not be able to get the edit dock request modal for another company's dock request" do
    edit_object_as(@other_user, edit_dock_request_path(@dock_request_1), true, false)
  end

  test "a logged in user should not be able to get the edit dock request modal if it's already checked out" do
    edit_object_as(@regular_user, edit_dock_request_path(@dock_request_checked_out), false, false)
    verify_assert_match(@dock_request_checked_out_remove)
    verify_alert_message(@danger, @checked_out)
  end

  test "a logged in user should not be able to get the edit dock request modal if it's already voided." do
    edit_object_as(@regular_user, edit_dock_request_path(@dock_request_voided), false, false)
    verify_assert_match(@dock_request_voided_remove)
    verify_alert_message(@danger, @voided)
  end

  # tests for who can update a dock request.
  test "a logged out user should not be able to update a dock request" do
    update_object_as(nil, @dock_request_1 ,dock_request_path(@dock_request_1), @dock_request_update_hash, @update_dock_request_array, false)
  end

  test "a logged in user should be able to update a dock request.  Also, a audit history entry should be created." do
    assert_difference 'DockRequestAuditHistory.count', 1 do
      update_object_as(@regular_user, @dock_request_1 ,dock_request_path(@dock_request_1), @dock_request_update_hash, @update_dock_request_array, true)
    end
    verify_audit_history_entry({ :event => "updated", :user_id => @regular_user.id, :company_id => @dock_request_1.company_id, :dock_request_id => @dock_request_1.id, :dock_id => nil, :phone_number => nil })
  end

  test "a logged in user that updates a dock request with nothing changed ahould not create a audit history entry." do
    assert_no_difference 'DockRequestAuditHistory.count' do
      params = { :dock_request => @dock_request_1.attributes }
      update_object_as(@regular_user, @dock_request_1 ,dock_request_path(@dock_request_1), params, [], true)
    end
  end

  test "a logged in user should not be able to update another company's dock request" do
    update_object_as(@other_user, @dock_request_1 ,dock_request_path(@dock_request_1), @dock_request_update_hash, @update_dock_request_array, false)
  end

  test "a logged in user should not be able to update a dock request with a dock group id that belongs to another company" do
    @dock_request_update_hash[:dock_request][:dock_group_id] = @other_company_dg.id
    @update_dock_request_array << "dock_group_id"
    update_object_as(@regular_user, @dock_request_1 ,dock_request_path(@dock_request_1), @dock_request_update_hash, @update_dock_request_array, false)
    assert_match /Dock group does not belong to your company/, @response.body
  end

  test "a logged in user should not be able to update a dock request if it's already checked out.  Also, no audit history entry should be created." do
    assert_no_difference 'DockRequestAuditHistory.count' do
      update_object_as(@regular_user, @dock_request_checked_out ,dock_request_path(@dock_request_checked_out), @dock_request_update_hash, @update_dock_request_array, false)
      verify_assert_match(@checked_out_or_voided)
    end
  end

  test "a logged in user should not be able to update a dock request if it's already voided" do
    update_object_as(@regular_user, @dock_request_voided ,dock_request_path(@dock_request_voided), @dock_request_update_hash, @update_dock_request_array, false)
    verify_assert_match(@checked_out_or_voided)
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

  test "a logged in user with more than one dock group should only see ACTIVE dock requests in their respective groups" do
    index_objects(@regular_user, dock_requests_path(dock_request: { dock_group_id: @cooler.id }), "dock_requests/index", true)
    # should see this dock request from cooler dock group
    assert_select "div#dock_request_#{@dock_request_1.id}"
    # shouldn't see this dock request that is voided.
    assert_select "div#dock_request_#{@dock_request_voided.id}", false
    # shouldn't see this dock request that is checked out.
    assert_select "div#dock_request_#{@dock_request_checked_out.id}", false
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

  # test for getting the assign dock request modal
  test "a user that is not logged in shouldn't get the assign dock modal" do
    edit_object_as(nil, dock_assignment_edit_dock_request_path(@dock_request_1), true, false)
  end

  test "a logged in user should be able to get the assign dock modal" do
    edit_object_as(@regular_user, dock_assignment_edit_dock_request_path(@dock_request_1), false, true)
  end

  test "a logged in user should not be able to get the assign dock modal for a dock request that belongs to another company" do
    edit_object_as(@other_user, dock_assignment_edit_dock_request_path(@dock_request_1), true, false)
  end

  test "a logged in user shouldn't be able to get the assign dock modal if the dock request is dock assigned already" do
    edit_object_as(@regular_user, dock_assignment_edit_dock_request_path(@dock_request_dock_assigned), false, false)
    verify_assert_match(@dock_request_dock_assigned_replace)
    verify_alert_message(@danger, @already_assigned)
  end

  test "a logged in user shouldn't be able to get the assign dock modal if the dock request is checked out" do
    edit_object_as(@regular_user, dock_assignment_edit_dock_request_path(@dock_request_checked_out), false, false)
    verify_assert_match(@dock_request_checked_out_remove)
    verify_alert_message(@danger, @checked_out)
  end

  test "a logged in user shouldn't be able to get the assign dock modal if the dock request is voided" do
    edit_object_as(@regular_user, dock_assignment_edit_dock_request_path(@dock_request_voided), false, false)
    verify_assert_match(@dock_request_voided_remove)
    verify_alert_message(@danger, @voided)
  end

  test "a logged in user shouldn't get the assign dock modal if the dock group has no enabled docks" do
    index_objects(@regular_user, dock_requests_path(dock_request: { dock_group_id: @dock_request_no_docks.dock_group_id }), "dock_requests/index", true)
    edit_object_as(@regular_user, dock_assignment_edit_dock_request_path(@dock_request_no_docks), false, false)
    verify_alert_message(@danger, @no_enabled_docks)
  end

  test "if there's a phone number, then there should be an option to send a text message when assigning a dock" do
    edit_object_as(@regular_user, dock_assignment_edit_dock_request_path(@dock_request_1), false, true)
    verify_assert_match("dock_request_text_message")
    verify_assert_match(@dock_request_1.phone_number)
  end

  test "if there is no phone number, there should not be an option to send a text message when assigning a dock" do
    @dock_request_1.update_attribute(:phone_number, nil)
    edit_object_as(@regular_user, dock_assignment_edit_dock_request_path(@dock_request_1), false, true)
    verify_assert_no_match("dock_request_text_message")
    verify_assert_no_match(@dock_request_1.phone_number)
  end

  # tests for assigning a dock to a dock request.
  test "a logged out user shouldn't be able to assign a dock" do
    update_object_as(nil, @dock_request_1, dock_assignment_update_dock_request_path(@dock_request_1), @dock_request_with_dock_hash, @dock_assign_unassign_array , false)
  end

  test "a logged in user should be able to assign a dock.  Also a audit history entry should be created." do
    assert_difference 'DockRequestAuditHistory.count', 1 do
      update_object_as(@regular_user, @dock_request_1, dock_assignment_update_dock_request_path(@dock_request_1), @dock_request_with_dock_hash, @dock_assign_unassign_array , true)
    end
    verify_audit_history_entry({ :event => "dock_assigned", :user_id => @regular_user.id, :company_id => @dock_request_1.company_id, :dock_request_id => @dock_request_1.id, :dock_id => @dock_request_1.dock_id, :phone_number => nil })
  end

  test "a logged in user should not be able to assign a dock for a dock request that belongs to another company" do
    update_object_as(@other_user, @dock_request_1, dock_assignment_update_dock_request_path(@dock_request_1), @dock_request_with_dock_hash, @dock_assign_unassign_array , false)
  end

  test "a logged in user should not be able to assign a dock if the dock is already assigned.  Also no audit history should be created." do
    assert_no_difference 'DockRequestAuditHistory.count' do
      update_object_as(@regular_user, @dock_request_dock_assigned, dock_assignment_update_dock_request_path(@dock_request_dock_assigned), @dock_request_with_dock_hash, @dock_assign_unassign_array , false)
      verify_assert_match(@not_checked_in)
    end
  end

  test "a logged in user should not be able to assign a dock if it's already checked out" do
    update_object_as(@regular_user, @dock_request_checked_out, dock_assignment_update_dock_request_path(@dock_request_checked_out), @dock_request_with_dock_hash, @dock_assign_unassign_array , false)
    verify_assert_match(@not_checked_in)
  end

  test "a logged in user should not be able to assign a dock if it's already voided" do
    update_object_as(@regular_user, @dock_request_voided, dock_assignment_update_dock_request_path(@dock_request_voided), @dock_request_with_dock_hash, @dock_assign_unassign_array , false)
    verify_assert_match(@not_checked_in)
  end

  test "if a dock is assigned with phone_number and text_message, 2 audit history entries should be created" do
    @dock_request_1.update_attribute(:phone_number, "0000000000")
    assert_difference 'DockRequestAuditHistory.count', 2 do
      update_object_as(@regular_user, @dock_request_1, dock_assignment_update_dock_request_path(@dock_request_1), @dock_request_with_dock_and_send_text_message, @dock_assign_unassign_array , true)
    end
    verify_audit_history_entry({ :event => "text_message_sent", :user_id => @regular_user.id, :company_id => @dock_request_1.company_id, :dock_request_id => @dock_request_1.id, :dock_id => nil, :phone_number => "0000000000" })
  end

  # tests for unassign dock.
  test "a logged out user should not be able to unassign a dock" do
    update_object_as(nil, @dock_request_dock_assigned, unassign_dock_dock_request_path(@dock_request_dock_assigned), nil, @dock_assign_unassign_array , false)
  end

  test "a logged in user should be able to unassign a dock" do
    assert_difference 'DockRequestAuditHistory.count', 1 do
      update_object_as(@regular_user, @dock_request_dock_assigned, unassign_dock_dock_request_path(@dock_request_dock_assigned), nil, @dock_assign_unassign_array , true)
    end
    verify_audit_history_entry({ :event => "dock_unassigned", :user_id => @regular_user.id, :company_id => @dock_request_dock_assigned.company_id, :dock_request_id => @dock_request_dock_assigned.id, :dock_id => nil, :phone_number => nil })
  end

  test "a logged in user should not be able to unassign a dock for a dock request belonging to another company" do
    update_object_as(@other_user, @dock_request_dock_assigned, unassign_dock_dock_request_path(@dock_request_dock_assigned), nil, @dock_assign_unassign_array , false)
  end

  test "a logged in user should not be able to unassign a dock if it's status is checked in" do
    update_object_as(@regular_user, @dock_request_1, unassign_dock_dock_request_path(@dock_request_1), nil, @dock_assign_unassign_array , false)
    verify_assert_match(@dock_request_1_replace)
    verify_alert_message(@danger, @no_longer_dock_assigned)
  end

  test "a logged in user should not be able to unassign a dock if it's status is checked out" do
    update_object_as(@regular_user, @dock_request_checked_out, unassign_dock_dock_request_path(@dock_request_checked_out), nil, @dock_assign_unassign_array , false)
    verify_assert_match(@dock_request_checked_out_remove)
    verify_alert_message(@danger, @checked_out)
  end

  test "a logged in user should not be able to unassign a dock if it's status is voided.  Also, no audit history should be created." do
    assert_no_difference 'DockRequestAuditHistory.count' do
      update_object_as(@regular_user, @dock_request_voided, unassign_dock_dock_request_path(@dock_request_voided), nil, @dock_assign_unassign_array , false)
    end
    verify_assert_match(@dock_request_voided_remove)
    verify_alert_message(@danger, @voided)
  end

  # tests for voiding
  test "a logged out user should not be able to void a dock request" do
    update_object_as(nil, @dock_request_1, void_dock_request_path(@dock_request_1), nil, @void_array , false)
  end

  test "a logged in user should be able to void a dock request.  Also a audit history entry should be created." do
    assert_difference 'DockRequestAuditHistory.count', 1 do
      update_object_as(@regular_user, @dock_request_1, void_dock_request_path(@dock_request_1), nil, @void_array , true)
    end
    verify_audit_history_entry({ :event => "voided", :user_id => @regular_user.id, :company_id => @dock_request_1.company_id, :dock_request_id => @dock_request_1.id, :dock_id => nil, :phone_number => nil })
  end

  test "a logged in user should not be able to void a dock request belonging to another company" do
    update_object_as(@other_user, @dock_request_1, void_dock_request_path(@dock_request_1), nil, @void_array , false)
  end

  test "a logged in user should not be able to void a dock request if it's status is dock assigned.  Also a audit history entry should not be created." do
    assert_no_difference 'DockRequestAuditHistory.count' do
      update_object_as(@regular_user, @dock_request_dock_assigned, void_dock_request_path(@dock_request_dock_assigned), nil, @void_array , false)
      verify_assert_match(@dock_request_dock_assigned_replace)
      verify_alert_message(@danger, @already_assigned)
    end
  end

  test "a logged in user should not be able to void a dock request if it's status is checked out" do
    update_object_as(@regular_user, @dock_request_checked_out, void_dock_request_path(@dock_request_checked_out), nil, @void_array , false)
    verify_assert_match(@dock_request_checked_out_remove)
    verify_alert_message(@danger, @checked_out)
  end

  test "a logged in user should not be able to void a dock request if it's status is already voided" do
    update_object_as(@regular_user, @dock_request_voided, void_dock_request_path(@dock_request_voided), nil, @void_array , false)
    verify_assert_match(@dock_request_voided_remove)
    verify_alert_message(@danger, @voided)
  end

  # tests for checking out
  test "a logged out user should not be able to check out a dock request" do
    update_object_as(nil, @dock_request_dock_assigned, check_out_dock_request_path(@dock_request_dock_assigned), nil, @check_out_array , false)
  end

  test "a logged in user should be able to check out a dock request.  Also a audit history entry should be created." do
    assert_difference 'DockRequestAuditHistory.count', 1 do
      update_object_as(@regular_user, @dock_request_dock_assigned, check_out_dock_request_path(@dock_request_dock_assigned), nil, @check_out_array , true)
    end
    verify_audit_history_entry({ :event => "checked_out", :user_id => @regular_user.id, :company_id => @dock_request_dock_assigned.company_id, :dock_request_id => @dock_request_dock_assigned.id, :dock_id => nil, :phone_number => nil })
  end

  test "a logged in user should not be able to check out a dock request from another company" do
    update_object_as(@other_user, @dock_request_dock_assigned, check_out_dock_request_path(@dock_request_dock_assigned), nil, @check_out_array , false)
  end

  test "a logged in user should not be able to check out a dock request that is status checked in.  Also no audit history should be created." do
    assert_no_difference 'DockRequestAuditHistory.count' do
      update_object_as(@regular_user, @dock_request_1, check_out_dock_request_path(@dock_request_1), nil, @check_out_array , false)
      verify_assert_match(@dock_request_1_replace)
      verify_alert_message(@danger, @no_longer_dock_assigned)
    end
  end

  test "a logged in user should not be able to check out a dock request that is already checked out" do
    update_object_as(@regular_user, @dock_request_checked_out, check_out_dock_request_path(@dock_request_checked_out), nil, @check_out_array , false)
    verify_assert_match(@dock_request_checked_out_remove)
    verify_alert_message(@danger, @checked_out)
  end

  test "a logged in user should not be able to check out a dock request that is already voided" do
    update_object_as(@regular_user, @dock_request_voided, check_out_dock_request_path(@dock_request_voided), nil, @check_out_array , false)
    verify_assert_match(@dock_request_voided_remove)
    verify_alert_message(@danger, @voided)
  end

  # tests for dock request history
  test "should see all dock requests from own company in any status within history but none from other companies." do
    index_objects(@regular_user, dock_requests_history_path, "dock_requests/history", true)
    # should see this dock request that is checked in
    assert_select "tr#dock_request_#{@dock_request_1.id}"
    # should see this dock request that is dock_assigned
    assert_select "tr#dock_request_#{@dock_request_dock_assigned.id}"
    # should see this dock request that is checked out.
    assert_select "tr#dock_request_#{@dock_request_checked_out.id}"
    # should see this dock request that is voided.
    assert_select "tr#dock_request_#{@dock_request_voided.id}"
    # should see this dock request dry dock group.
    assert_select "tr#dock_request_#{@dock_request_3.id}"
    # shouldn't see these dock requests from other companies.
    assert_select "tr#dock_request_#{@dock_request_2.id}", false
    assert_select "tr#dock_request_#{@delete_me_dock_request.id}", false
  end

  # tests notification of a stale dock request no longer existing because it was delteted.
  test "if a dock request is deleted and a user trys to show, edit, or update it, they are warned the dock request no longer exists." do
    controller_methods = { show: { get: dock_request_path(@delete_me_dock_request) }, update: { patch: dock_request_path(@delete_me_dock_request) },
    edit: { get: edit_dock_request_path(@delete_me_dock_request) }, dock_assignment_edit: { get: dock_assignment_edit_dock_request_path(@delete_me_dock_request) },
    dock_assignment_update: { patch: dock_assignment_update_dock_request_path(@delete_me_dock_request) }, unassign_dock: { patch: unassign_dock_dock_request_path(@delete_me_dock_request) },
    check_out: { patch: check_out_dock_request_path(@delete_me_dock_request) }, void: { patch: void_dock_request_path(@delete_me_dock_request) } }

    hash = { dock_request: { primary_reference: "updated reference" } }
    text = DockRequest.no_longer_exists_alert_message
    check_if_object_deleted(@delete_me_admin, controller_methods, hash, text, false)
    @delete_me_dock_request.destroy
    check_if_object_deleted(@delete_me_admin, controller_methods, hash, text, true)
  end






















end

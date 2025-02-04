function hideShowEverythingPermissions() {
  var $everything = $('#access_policy_everything')
  var $individual_permissions = $('div.individual_permissions')
  if($everything.is(':checked')) {
    $individual_permissions.find(':input').prop("checked", false);
    $individual_permissions.hide();
  } else {
    $individual_permissions.show();
  }
}

function hideShowDockQueuePermissions() {
  var $dock_queue = $('#access_policy_dock_queue')
  var $dock_queue_sub_permissions = $('div.dock_queue_sub_permissions')
  if($dock_queue.is(':checked')) {
    $dock_queue_sub_permissions.show();
  } else {
    $dock_queue_sub_permissions.find(':input').prop("checked", false);
    $dock_queue_sub_permissions.hide();
  }
}

function populateAccessPoliciesSelect() {
  $("#auth_user_company_id:not(.bound)").addClass("bound").on("change", function(){
    var company = $(this).val();
    $.ajax({
      url: "/access_policies/company",
      method: "GET",
      dataType: "json",
      data: {company: company},
      error: function (xhr, status, error) {
        console.error("AJAX Error: " + status + error);
      },
      success: function (response) {
        var access_policy_select = $("#auth_user_access_policy_id");
        access_policy_select.empty();
        access_policy_select.append("<option value>Please select</option>");
        var access_policies = response["access_policies"];
        for(var i=0; i< access_policies.length; i++){
          access_policy_select.append('<option value="' +
            access_policies[i]["id"] + '">' + access_policies[i]["description"]
            + '</option>');
        }
      }
    });
  });
}

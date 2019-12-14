function hideAccessPolicyPermissions() {
  var $everything = $('#access_policy_everything')
  var $individual_permissions = $('div.individual_permissions')
  if($everything.is(':checked')) {
    $individual_permissions.find(':input').prop("checked", false);
    $individual_permissions.hide();
  } else {
    $individual_permissions.show();
  }
}

function populateAccessPoliciesSelect() {
  $("#user_company_id:not(.bound)").addClass("bound").on("change", function(){
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
        var access_policy_select = $("#user_access_policy_id");
        access_policy_select.empty();
        access_policy_select.append("<option></option>");
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

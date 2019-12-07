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

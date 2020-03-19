$( document ).on('show.bs.modal', function () {
  if ($('body.access_policies.index').length > 0) {
    hideShowEverythingPermissions()
    bindEverything()
    hideShowDockQueuePermissions()
    bindDockQueue()
  }
})

/* Hides all other permissions if everything is enabled, shows if not.
   Also disables all other permissions if everything is enabled. */
function hideShowEverythingPermissions() {
  var $individual_permissions = $('div.individual_permissions')
  if($('#access_policy_everything').is(':checked')) {
    $individual_permissions.find(':input').prop("checked", false);
    $individual_permissions.hide();
  } else {
    $individual_permissions.show();
  }
}

// If everything changes, need to hide/show other permissions.
function bindEverything() {
  $("#access_policy_everything:not(.bound)").addClass("bound").on("change", function(){
    hideShowEverythingPermissions()
  })
}

/* Shows sub dock queue permissions if dock queue is enabled, hides if not.
   Also disables the sub permission if dock queue is disabled. */
function hideShowDockQueuePermissions() {
  var $dock_queue_sub_permissions = $('div.dock_queue_sub_permissions')
  if($('#access_policy_dock_queue').is(':checked')) {
    $dock_queue_sub_permissions.show();
  } else {
    $dock_queue_sub_permissions.find(':input').prop("checked", false);
    $dock_queue_sub_permissions.hide();
  }
}

// If dock queue changes, need to hide/show sub permissions.
function bindDockQueue() {
  $("#access_policy_dock_queue:not(.bound)").addClass("bound").on("change", function(){
    hideShowDockQueuePermissions()
  })
}

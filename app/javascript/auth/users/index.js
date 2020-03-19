import { Ajax } from "ajax"

$( document ).on('show.bs.modal', function () {
  if ($('body.users.index').length > 0) {
    userCompanyDynamicAccessPolicies()
  }
})

/*  This function is for a app admin only.
    When creating or modifying a user as an app admin,
    the access policies in the select need to be the
    ones for the user's company.  As you change the
    user's company, the access policy select is updated. */
function userCompanyDynamicAccessPolicies() {
  var company = $("#auth_user_company_id:not(.bound)")
  company.addClass("bound").on("change", function(){
    Ajax.replaceSelectOptions(
      { url: "/access_policies/company",
        data: { company: company.val() },
        response_function: response => response["access_policies"],
        select_options: {
          select_id: "#auth_user_access_policy_id",
          label_method: "description"
        }
      }
    )
  })
}

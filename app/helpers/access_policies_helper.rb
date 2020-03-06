module AccessPoliciesHelper

  def permission(form, permission, label)
    return "" unless Auth::AccessPolicyUtil.check_permission_company_type(permission)
    form.input permission, sf_switch(label: label)
  end

end

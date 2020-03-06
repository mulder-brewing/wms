module Auth::AccessPolicyUtil

  def self.current_access_policy
    Current.access_policy ||= Auth::CurrentUtil.current_user&.access_policy
  end

  def self.check?(permission)
    return false unless check_permission_company_type(permission)
    current_access_policy&.check(permission)
  end

  def self.check_permission_company_type(permission)
    company_type = Auth::CurrentUtil.current_company_type
    Auth::PermissionsCO.check_permission_against_company_type(permission, company_type)
  end


end

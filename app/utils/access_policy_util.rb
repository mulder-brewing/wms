module AccessPolicyUtil

  def self.current_access_policy
    Current.access_policy ||= Current.user.access_policy
  end

  def self.check?(permission)
    current_access_policy&.check(permission)
  end


end

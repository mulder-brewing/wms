module UserUtil

  def self.app_admin?
    Current.user&.app_admin
  end

  def self.company_admin?
    Current.user&.company_admin
  end

  def self.admin?
    app_admin? || company_admin?
  end

end

module CurrentUtil

  def self.current_user
    Current.user
  end

  def self.current_company
    Current.company ||= current_user.company
  end

  def self.current_company_type
    current_company.company_type
  end

  def self.current_company_id
    current_company.id
  end
end

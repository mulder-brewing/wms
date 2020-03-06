module Auth::CurrentUtil

  def self.current_user
    Current.user
  end

  def self.current_company
    Current.company ||= current_user.company
  end

  def self.current_company_type
    current_company.company_type
  end
end

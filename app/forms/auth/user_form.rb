class Auth::UserForm < BasicRecordForm

  validate :access_policy_valid

  attr_accessor :companies, :access_policies

  delegate  :company_id, :company_id=,
            :first_name, :first_name=,
            :last_name, :last_name=,
            :email, :email=,
            :username, :username=,
            :company_admin, :company_admin=,
            :access_policy_id, :access_policy_id=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "Auth::User")
  end

  def initialize(*)
    super
    @table_class = Table::Auth::UsersIndexTable
  end

  def setup_variables
    @companies = Company.all.order(:name) if app_admin?

    company_id = @record.company_id || current_company_id
    @access_policies = AccessPolicy.select_options(company_id,
      record.access_policy_id).order(:description)
    if action?(:new) && @access_policies.length == 1
      @record.access_policy_id = @access_policies.first.id
    end
  end

  private

  def access_policy_valid
    validate_company_id(AccessPolicy, :access_policy_id)
  end

end

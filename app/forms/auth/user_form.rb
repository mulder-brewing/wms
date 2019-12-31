class Auth::UserForm < RecordForm

  def self.model_name
    ActiveModel::Name.new(self, nil, "Auth::User")
  end

  validate :user_valid

  attr_accessor :user

  delegate  :company_id,
            :first_name,
            :last_name,
            :email,
            :username,
            :company_admin,
            :access_policy_id,
            to: :@user

  def record
    @user
  end

  def persisted?
    @user.persisted?
  end

  def id
    @user.id
  end

  private

  def user_valid
    unless @user.valid?
      errors.merge!(@user.errors)
    end
  end

end

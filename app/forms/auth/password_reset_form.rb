class Auth::PasswordResetForm < BasicRecordForm

  validates :password, presence: true
  validates :password_confirmation, presence: true
  validate :password_repeat?

  delegate  :password, :password=,
            :password_confirmation, :password_confirmation=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "Auth::PasswordReset")
  end

  def prep_record(params)
    @record = Auth::User.find(params[:id])
  end

  def submit
    @record.password_reset = false
    super
  end

  def permitted_params
    [:password, :password_confirmation]
  end

  def password_repeat?
    if BCrypt::Password.new(@record.password_digest_was) == password
      errors.add(:password, I18n.t("form.errors.same"))
    end
  end

end

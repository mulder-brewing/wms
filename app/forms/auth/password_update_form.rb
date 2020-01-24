class Auth::PasswordUpdateForm < BasicRecordForm

  validates :password, presence: true
  validates :password_confirmation, presence: true
  validate :email_exists_if_send_email
  validate :not_self_if_send_email

  attr_accessor :send_email

  delegate  :password, :password=,
            :password_confirmation, :password_confirmation=,
            :email, :email=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "Auth::PasswordUpdate")
  end

  def prep_record(params)
    @record = Auth::User.find(params[:id])
  end

  def submit
    @record.password_reset = true unless self?(@record)
    super
    if send_email? && @submit_success
      send_password_reset_email
    end
  end

  def permitted_params
    [:password, :password_confirmation, :email, :send_email]
  end

  private

  def send_password_reset_email
    UserMailer.password_reset(@record).deliver_now
  end

  def send_email?
    @send_email_bool = Util::Boolean.cast(@send_email)
  end

  def email_exists_if_send_email
    unless Util::Email::SendPossible.call(@record.email, @send_email)
      errors.add(:email, :blank_send)
      errors.add(:send_email, :blank_email)
    end
  end

  def not_self_if_send_email
    if send_email? && self?(@record)
      errors.add(:send_email, :self)
    end
  end

end

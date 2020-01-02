class Auth::UserEditUpdateForm < Auth::UserForm

  validate :self_disable_check
  validate :self_unadmin_check

  delegate  :enabled, :enabled=, to: :@record

  def initialize(*)
    super
    @view_class = self.class.superclass
  end

  def permitted_params
    permitted = [:email]
    if admin?
      permitted.push(:first_name, :last_name, :username, :company_admin,
        :access_policy_id, :enabled)
      permitted << :company_id if app_admin?
    end
    return permitted
  end

  def self_disable_check
    if current_user?(@record) && @record.enabled_changed?
      #are you trying to disable yourself?
      errors.add(:enabled,
        I18n.t("form.errors.disabled_self")) if @record.enabled == false
    end
  end

  def self_unadmin_check
    if current_user?(@record) && @record.company_admin_changed?
      #are you trying to unadmin yourself?
      errors.add(:company_admin,
        I18n.t("form.errors.disabled_self")) if @record.company_admin == false
    end
  end

end

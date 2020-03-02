module Auth::SessionsHelper

  # Logs the user in with session
  def log_in(user)
    session[:user_id] = user.id
  end

  # Logs the user out with session
  def log_out
    session.delete(:user_id)
    Current.user = nil
  end

  # Returns the current logged-in user (if any).
  def current_user
   if session[:user_id]
     Current.user ||= Auth::User.find_by(id: session[:user_id])
   end
  end

  # Returns true if the user is logged in, otherwise false.
  def logged_in?
    !current_user.nil?
  end

  #Returns true if the user is the currently logged in user.
  def current_user?(user)
    user == current_user
  end

  #Returns true if the current_user is app_admin
  def app_admin?
    current_user.app_admin
  end

  #Returns true if the current_user is company_admin
  def company_admin?
    current_user.company_admin
  end

  #Returns true if the current user is company_admin or app_admin
  def admin?
    app_admin? || company_admin?
  end

  #Returns ture is the current user is logged in and a app_admin.
  def logged_in_app_admin?
    logged_in? && app_admin?
  end

  #Returns true if the current_user is logged in and a company_admin.
  def logged_in_company_admin?
    logged_in? && company_admin?
  end

  #Returns true if the current user is logged in as company admin or app admin.
  def logged_in_admin?
    logged_in? && (app_admin? || company_admin?)
  end

  #Returns true if the user belongs to the same company as the current user
  def same_company_as_current_user?(object)
    current_company_id == object.company_id
  end

  def redirect_if_company_mismatch(object)
    if !logged_in_app_admin?
      all_formats_redirect_to(root_url) if !same_company_as_current_user?(object)
    end
  end

  def needs_password_reset?
    current_user.password_reset
  end

  def current_company_id
    current_user.company_id
  end

  def not_self?(user)
    !(user == current_user)
  end

  def self?(user)
    user == current_user
  end

  # Returns the current user's access policy
  def current_access_policy
    AccessPolicyUtil.current_access_policy
  end

  def ap_check?(permission)
    current_access_policy&.check(permission)
  end
end

module SessionsHelper

  # Logs the user in with session
  def log_in(user)
    session[:user_id] = user.id
  end

  # Logs the user out with session
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns the current logged-in user (if any).
  def current_user
   if session[:user_id]
     @current_user ||= User.find_by(id: session[:user_id])
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

  #Returns ture is the current user is logged in and a app_admin.
  def logged_in_app_admin?
    logged_in? && app_admin?
  end

  #Returns true if the current_user is logged in and a company_admin.
  def logged_in_company_admin?
    logged_in? && company_admin?
  end
=======
>>>>>>> 222d199d41cf3cc936b808c72883d03580690efc
=======
>>>>>>> 222d199d41cf3cc936b808c72883d03580690efc
end

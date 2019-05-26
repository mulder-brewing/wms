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
end

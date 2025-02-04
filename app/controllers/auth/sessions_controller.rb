class Auth::SessionsController < ApplicationController

  skip_before_action :logged_in, :only => [:new, :create]
  skip_before_action :check_reset_password, :only => [:destroy]
  before_action :logged_in_app_admin, :only => [:become_user]
  before_action :skip_authorization

  def new
    all_formats_redirect_to(root_url) if logged_in?
  end

  def create
    user = Auth::User.find_by(username: params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:password]) && user.enabled && user.company.enabled
      log_in_redirect_root(user)
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    all_formats_redirect_to(root_url)
  end

  def become_user
    user = find_user_by_id(params[:id])
    if user.nil?
      flash[:warning] = 'User no longer exists'
      redirect_to users_url
    else
      log_in_redirect_root(user)
    end
  end

  private
    def log_in_redirect_root(user)
      log_in(user)
      flash[:success] = 'Logged In!' if user.password_reset != true
      redirect_to root_url
    end
end

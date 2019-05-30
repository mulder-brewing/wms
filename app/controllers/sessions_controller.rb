class SessionsController < ApplicationController
  skip_before_action :logged_in, :only => [:new, :create]

  def new
    all_formats_redirect_to(root_url) if logged_in?
  end

  def create
    user = User.find_by(username: params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:password]) && user.enabled && user.company.enabled
      log_in(user)
      flash[:success] = 'Logged In!'
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end

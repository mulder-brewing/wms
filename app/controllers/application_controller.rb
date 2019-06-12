class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper
  before_action :logged_in
  before_action :check_reset_password

  rescue_from ActionController::InvalidAuthenticityToken do
    all_formats_redirect_to(root_url)
  end

  def all_formats_redirect_to(path)
    respond_to do |format|
      format.html { redirect_to path }
      format.js { render js: "window.location = #{path.to_json}" }
    end
  end

  private
    def logged_in
      all_formats_redirect_to(root_url) unless logged_in?
    end

    def logged_in_admin
      all_formats_redirect_to(root_url) unless logged_in_admin?
    end

    def logged_in_app_admin_redirect
      all_formats_redirect_to(root_url) unless logged_in_app_admin?
    end

    def find_user_by_id(id)
      @user = User.find_by(id: id)
    end

    def check_reset_password
      all_formats_redirect_to(update_password_user_url(current_user)) if logged_in? && needs_password_reset?
    end

end

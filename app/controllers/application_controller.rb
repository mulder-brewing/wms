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

    # These functions help with locating a object for a model, setting current_user for the model, and redirecting to root url if that object is invalid.
    def find_object_redirect_invalid(model)
      object = find_object_by_id(model)
      return nil if object.nil?
      object_with_current_user = set_current_user(object)
      redirect_if_object_invalid(object_with_current_user)
      return object_with_current_user
    end

    def find_object_by_id(model)
      return model.find_by(id: params[:id])
    end

    def redirect_if_object_invalid(object)
      all_formats_redirect_to(root_url) if !object.valid?
    end

    def set_current_user(object)
      object.current_user = current_user
      return object
    end

    # This can be used to set the current user attribute for an object that is a instance variable.
    def set_current_user_attribute(instance_variable)
      instance_variable_get("@#{instance_variable}").current_user = current_user
    end

end

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Auth::SessionsHelper
  include FindObjectHelper
  include Pundit

  before_action :logged_in
  before_action :check_reset_password
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

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
    def raise_not_authorized
      raise Pundit::NotAuthorizedError
    end

    def not_authorized
      flash[:danger] = t("alert.not_authorized")
      all_formats_redirect_to(root_url)
    end

    def not_found
      respond_to do |format|
        format.html {
                      flash[:warning] = t("alert.record.not_found")
                      redirect_back(fallback_location: root_path)
                    }
        format.js { render :template => "shared/not_found" }
      end
    end

    def logged_in
      raise_not_authorized unless logged_in?
    end

    def logged_in_admin
      raise_not_authorized unless logged_in_admin?
    end

    def logged_in_app_admin
      raise_not_authorized unless logged_in_app_admin?
    end

    def find_user_by_id(id)
      @user = Auth::User.find_by(id: id)
    end

    def check_reset_password
      if logged_in? && needs_password_reset?
        all_formats_redirect_to(edit_auth_password_reset_path(current_user))
      end
    end

    # This can be used to set the current user attribute for an object that is a instance variable.
    def set_current_user_attribute(instance_variable)
      instance_variable_get("@#{instance_variable}").current_user = current_user
    end

    def select_options(model, record_id, company_id)
      model.select_options(company_id ||= current_company_id, record_id)
    end

    def action_sym
      action_name.to_sym
    end

end

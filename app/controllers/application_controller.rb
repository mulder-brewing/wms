class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper
  include Pundit

  before_action :logged_in
  before_action :check_reset_password
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  RecordNotFound = Class.new(StandardError)
  rescue_from ApplicationController::RecordNotFound, with: :not_found

  rescue_from ActionController::InvalidAuthenticityToken do
    all_formats_redirect_to(root_url)
  end

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

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

    def raise_not_found
      raise ApplicationController::RecordNotFound
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
      @user = User.find_by(id: id)
    end

    def check_reset_password
      all_formats_redirect_to new_password_form_path if logged_in? && needs_password_reset?
    end

    # These functions help with locating a object for a model
    # and setting current_user for the model.
    def find_object_with_current_user(model)
      object = find_object_by_id(model)
      raise_not_found if object.nil?
      object_with_current_user = set_current_user(object)
      return object_with_current_user
    end

    def find_object_by_id(model)
      return model.find_by(id: params[:id])
    end

    def find_record
      find_object_with_current_user(controller_model)
    end

    def set_current_user(object)
      object.current_user = current_user
      return object
    end

    # This can be used to set the current user attribute for an object that is a instance variable.
    def set_current_user_attribute(instance_variable)
      instance_variable_get("@#{instance_variable}").current_user = current_user
    end

    def controller_model
      controller_name.classify.constantize
    end

    def select_options(model, record_id = nil, company_id = current_company_id)
      model.select_options(company_id, record_id).order(:description)
    end

end

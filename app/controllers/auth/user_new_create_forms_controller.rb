class Auth::UserNewCreateFormsController < ApplicationController
  include GenericModalFormPageHelper
  include Auth::UsersIndexTable

  def new
    new_modal
  end

  def create
    create_record
  end

  private

  def record_params
    admin_params = [:first_name, :last_name, :email, :username,
      :password, :password_confirmation, :company_admin, :access_policy_id,
      :send_email]
    admin_params << :company_id if app_admin?
    params.require(controller_model.record_name).permit(admin_params)
  end

  def modal_form_callback(modal_form)
    # this makes it so the form partial comes from the users folder.
    modal_form.form.controller_path = Auth::UsersController.controller_path
  end

  def record_callback(record)
    # Setup options for the selects
    @companies = Company.all.order(:name) if app_admin?
    if action_sym == :new && app_admin?
      @access_policies = AccessPolicy.none
    else
      @access_policies = select_options(AccessPolicy, record.access_policy_id,
                            record.company_id).order(:description)
    end
  end

end

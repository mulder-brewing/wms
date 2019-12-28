class Auth::UsersController < Auth::BaseController
    include GenericModalFormPageHelper
    include Auth::UsersIndexTable

    def edit
      edit_modal
    end

    def update
      update_record
    end

    def index
      index_page
    end

    private
      def record_params
        admin_params = [:username, :first_name, :last_name, :email, :enabled,
          :password, :password_confirmation, :company_admin, :send_email,
          :access_policy_id]
        if logged_in_app_admin?
          params.require(:auth_user).permit(:company_id, admin_params)
        elsif logged_in_company_admin?
          params.require(:auth_user).permit(admin_params)
        else
          params.require(:auth_user).permit(:email, :password, :password_confirmation)
        end
      end

      def record_callback(record)
        # Setup options for the selects.
        @companies = Company.all.order(:name) if app_admin?
        @access_policies = select_options(AccessPolicy, record.access_policy_id,
                              record.company_id).order(:description)
      end

      def modal_form_callback(modal_form)
        modal_form.form.show_timestamps = false if !admin?
      end

end

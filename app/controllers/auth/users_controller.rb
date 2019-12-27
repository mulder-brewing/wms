class Auth::UsersController < Auth::BaseController
    include GenericModalFormPageHelper

    skip_before_action :check_reset_password,
      :only => [:update_password_commit, :update_password]

    def new
      new_modal
    end

    def create
      create_record
    end

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

      def table_array_hash
        array = []
        array << { name: :actions, edit_button: true, become_button: true }
        array << { name: :username, text_key: "auth/users.name.username" }
        array << { name: :company, text_key: "companies.company",
                  send_chain: ["company", "name"] } if logged_in_app_admin?
        array << { name: :enabled, text_key_qualifier: :enabled }
      end

      def record_callback(record, action)
        ap = -> (x = nil, y = current_company_id) {
          @access_policies = (y.nil? ? AccessPolicy.none
                                    : select_options(AccessPolicy, x, y))
                                    .order(:description) }
        d = -> { ap.(record.access_policy_id, record.company_id) }
        cmp = -> { @companies = Company.all.order(:name) if app_admin? }
        e = -> (x) { record.send_what_email = x }
        case action
        when :new
          app_admin? ? ap.(nil, nil) : ap.()
          cmp.()
        when :create
          e.("create"); d.(); cmp.()
        when :edit
          d.(); cmp.()
        when :update
          e.("password-reset"); d.(); cmp.()
        end
        return record
      end

end

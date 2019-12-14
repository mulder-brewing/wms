class UsersController < ApplicationController
    include GenericModalFormPageHelper

    before_action :logged_in_admin,
      except: [:edit, :update, :update_password, :update_password_commit]
    skip_before_action :check_reset_password,
      :only => [:update_password_commit, :update_password]
    before_action :skip_authorization

    def new
      new_modal
    end

    def create
      record = controller_model.new(record_params)
      record.company_id ||= current_user.company_id
      record.assign_attributes( { :send_what_email => "create",
                                  :current_user => current_user } )
      create_record(record)
    end

    def edit
      edit_modal
    end

    def update
      record = find_record
      unless record.nil?
        record.send_what_email = "password-reset"
        record.assign_attributes(record_params)
      end
      update_record(record)
    end

    def index
      if logged_in_app_admin?
        records = User.all_except(current_user).order(:username)
      else
        records = User.where_company_users_except(current_user).order(:username)
      end

      page = Page::IndexListPage.new
      page.records = records
      index_page(page)
    end

    def update_password
      record = find_record
      render :locals => { user: record }
    end

    def update_password_commit
      record = find_record
      record.context_password_reset = true
      record.update(record_params)
      if record.password_reset == false
        flash[:success] = t("alert.save.password_success")
        all_formats_redirect_to(root_url)
      else
        render 'update_password', :locals => { user: record }
      end
    end

    private
      def record_params
        admin_params = [:username, :first_name, :last_name, :email, :enabled,
          :password, :password_confirmation, :company_admin, :send_email,
          :access_policy_id]
        if logged_in_app_admin?
          params.require(:user).permit(:company_id, admin_params)
        elsif logged_in_company_admin?
          params.require(:user).permit(admin_params)
        else
          params.require(:user).permit(:email, :password, :password_confirmation)
        end
      end

      def table_array_hash
        array = []
        array << { name: :actions, edit_button: true, become_button: true }
        array << { name: :username, text_key: "users.name.username" }
        array << { name: :company, text_key: "companies.company",
                  send_chain: ["company", "name"] } if logged_in_app_admin?
        array << { name: :enabled, text_key_qualifier: :enabled }
      end
end

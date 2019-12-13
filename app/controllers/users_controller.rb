class UsersController < ApplicationController
    include GenericModalFormPageHelper

    before_action :logged_in_admin, except: [:edit, :update, :update_password, :update_password_commit]
    skip_before_action :check_reset_password, :only => [:update_password_commit, :update_password]
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
      enabled = ActiveRecord::Type::Boolean.new.deserialize(enabled_only_params[:enabled])
      if logged_in_app_admin?
        records = User.all_except(current_user).order(:username)
      else
        records = User.where_company_users_except(current_user).order(:username)
      end
      records = records.where_enabled(enabled) unless enabled.nil?
      pagy, records = pagy(records, items:25)

      page = Page::GenericPage.new(:index, records)
      page.add_table(table_array_hash)
      page.enabled_param = enabled

      respond_to do |format|
        format.html {
          render  :template => page.index_html_path,
                  :locals => {  page: page,
                                pagy: pagy
                  }
        }
      end
    end

    def update_password
      user = find_record
      render :locals => { user: user }
    end

    def update_password_commit
      user = find_record
      user.context_password_reset = true
      user.update(record_params)
      if user.password_reset == false
        flash[:success] = t("alert.save.password_success")
        all_formats_redirect_to(root_url)
      else
        render 'update_password', :locals => { user: user }
      end
    end

    private
      def record_params
        admin_params = [:username, :first_name, :last_name, :email, :enabled, :password, :password_confirmation, :company_admin, :send_email]
        if logged_in_app_admin?
          params.require(:user).permit(:company_id, admin_params)
        elsif logged_in_company_admin?
          params.require(:user).permit(admin_params)
        else
          params.require(:user).permit(:email, :password, :password_confirmation)
        end
      end

      def find_user
        @user = find_object_redirect_invalid(User)
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

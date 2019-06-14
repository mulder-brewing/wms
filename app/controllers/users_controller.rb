class UsersController < ApplicationController
    before_action :logged_in_admin, except: [:edit, :update, :update_password, :update_password_commit]
    skip_before_action :check_reset_password, :only => [:update_password_commit, :update_password]

    def new
      @user = User.new
      respond_to :js
    end

    def create
      @user = User.new(user_params)
      @user.company_id ||= current_user.company_id
      @user.send_what_email = "create"
      set_current_user
      @user.save
      respond_to :js
    end

    def show
      find_user_redirect_invalid
      respond_to :js
    end

    def edit
      find_user_redirect_invalid
      respond_to :js
    end

    def update
      find_user_redirect_invalid
      @user.update_attributes(user_params)
      respond_to :js
    end

    def index
      if current_user.app_admin
        @pagy, @users = pagy(User.all_except(current_user).order(:username), items:25)
      else
        @pagy, @users = pagy(User.where_company_users_except(current_user).order(:username), items:25)
      end
    end

    def update_password
      find_user_redirect_invalid
    end

    def update_password_commit
      find_user_redirect_invalid
      @user.context_password_reset = true
      @user.update_attributes(user_params)
      if @user.password_reset == false
        flash[:success] = 'Password successfully updated!'
        all_formats_redirect_to(root_url)
      else
        render 'update_password'
      end
    end

    private
      def user_params
        admin_params = [:username, :first_name, :last_name, :email, :enabled, :password, :password_confirmation, :company_admin, :send_email]
        if logged_in_app_admin?
          params.require(:user).permit(:company_id, admin_params)
        elsif logged_in_company_admin?
          params.require(:user).permit(admin_params)
        else
          params.require(:user).permit(:email, :password, :password_confirmation)
        end
      end

      def redirect_if_user_invalid
        all_formats_redirect_to(root_url) if !@user.valid?
      end

      def set_current_user
        @user.current_user = current_user
      end

      def find_user_redirect_invalid
        find_user_by_id(params[:id])
        set_current_user
        redirect_if_user_invalid
      end


end

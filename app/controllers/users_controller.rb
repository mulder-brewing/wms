class UsersController < ApplicationController
    before_action :logged_in_admin, except: [:edit, :update]
    before_action :check_company, only: [:edit]

    def new
      @user = User.new
      respond_to :js
    end

    def create
      @user = User.new(user_params)
      @user.company_id ||= current_user.company_id
      @user.save
      respond_to :js
    end

    def show
      @user = User.find_by(id: params[:id])
      respond_to :js
    end

    def edit
      @user = User.find_by(id: params[:id])
      respond_to :js
    end

    def update
      @user = User.find(params[:id])
      admin = @user.company_admin
      @user.assign_attributes(user_params)
      if current_user?(@user) && admin
        @user.save(context: :self)
      else
        @user.save
      end
      respond_to :js
    end

    def index
      if current_user.app_admin
        @pagy, @users = pagy(User.all_except(current_user).order(:username), items:25)
      else
        @pagy, @users = pagy(User.where(company_id: current_user.company_id).where_except(current_user).order(:username), items:25)
      end
    end

    private
      def user_params
        if current_user.app_admin
          params.require(:user).permit(:company_id, :username, :first_name, :last_name, :email, :enabled, :password, :password_confirmation, :company_admin )
        elsif current_user.company_admin
          params.require(:user).permit(:username, :first_name, :last_name, :email, :enabled, :password, :password_confirmation, :company_admin )
        else
          params.require(:user).permit(:email, :password, :password_confirmation)
        end
      end

      def logged_in_admin
        all_formats_redirect_to(root_url) unless logged_in_admin?
      end

      def check_company
        @user = User.find_by(id: params[:id])
        all_formats_redirect_to(root_url) unless same_company_as_current_user?(@user) || current_user.app_admin?
      end


end

class AccessPoliciesController < ApplicationController
  include GenericModalFormPageHelper

  before_action :skip_authorization
  before_action :logged_in_admin

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

  def company
    if params[:company].present?  && logged_in_app_admin?
      access_policies = AccessPolicy.where_company(params[:company])
    else
      access_policies = AccessPolicy.none
    end
    if request.xhr?
      respond_to do |format|
        format.json {
          render json: { access_policies: access_policies }
        }
      end
    end
  end

  private
    def record_params
      params.require(:access_policy).permit(:description, :enabled, :everything, :dock_groups, :docks)
    end

    def table_array_hash
      array = []
      array << { name: :actions, edit_button: true }
      array << { name: :description }
      array << { name: :enabled, text_key_qualifier: :enabled }

    end

    def recordsSendArray
      array = []
      array << [:order, :description]
    end
end

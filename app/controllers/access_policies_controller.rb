class AccessPoliciesController < ApplicationController
  include FormHelper, ModalHelper, PageHelper

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
    page = new_page_prep_records(Page::IndexListPage)
    page.table = Table::Auth::UsersIndexTable.new(current_user)
    authorize_scope_records(page)
    pagy_records(page)
    render_page(page)
  end

  def company
    if params[:company].present?  && app_admin?
      access_policies = AccessPolicy.enabled_where_company(params[:company])
                                    .order(:description)
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

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
    index_page(recordSendArray)
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

    def recordSendArray
      array = []
      array << [:order, :description]
    end
end

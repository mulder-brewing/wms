class DockGroupsController < ApplicationController
  include GenericModalFormPageHelper

  before_action :logged_in_admin
  before_action :skip_authorization

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
      params.require(:dock_group).permit(:description, :enabled)
    end

    def table_array_hash
      [
        { name: :actions, edit_button: true },
        { name: :description },
        { name: :enabled, text_key_qualifier: :enabled }
      ]
    end

    def recordsSendArray
      array = []
      array << [:order, :description]
    end
end

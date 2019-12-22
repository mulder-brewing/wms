class DocksController < ApplicationController
  include GenericModalFormPageHelper

  def new
    find_enabled_dock_groups
    new_modal
  end

  def create
    find_enabled_dock_groups
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
      params.require(:dock).permit(:number, :dock_group_id, :enabled)
    end

    def table_array_hash
      array = []
      array << { name: :actions, edit_button: true }
      array << { name: :number }
      array << {  name: :dock_group, text_key: "dock_groups.dock_group",
                  send_chain: ["dock_group", "description"]
                }
      array << { name: :enabled, text_key_qualifier: :enabled }
    end

    def record_callback(record, action)
      case action
        when :new
          if @dock_groups.length == 1
            record.dock_group_id = @dock_groups.first.id
          end
        when :edit, :update
          find_enabled_dock_groups(record)
      end
      return record
    end

    def find_enabled_dock_groups(record = nil)
      @dock_groups = !record.nil? ?
        DockGroup.record_options(current_company_id, record.dock_group_id) :
        DockGroup.enabled_where_company(current_company_id)
      @dock_groups = @dock_groups.order(:description)
    end
end

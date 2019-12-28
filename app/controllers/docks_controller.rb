class DocksController < ApplicationController
  include GenericModalFormPageHelper

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

    def record_callback(record)
      p = -> (x = nil) { @dock_groups = select_options(DockGroup, x) }
      case action_sym
      when :new, :create
          p.()
          if @dock_groups.length == 1
            record.dock_group_id = @dock_groups.first.id
          end
        when :edit, :update
          p.(record.dock_group_id)
      end
      return record
    end

end

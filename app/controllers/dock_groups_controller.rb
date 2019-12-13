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
    enabled = ActiveRecord::Type::Boolean.new.deserialize(enabled_only_params[:enabled])
    records = controller_model.where_company(current_company_id).order(:description)
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
end

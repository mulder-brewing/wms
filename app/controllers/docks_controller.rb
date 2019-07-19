class DocksController < ApplicationController
  before_action :logged_in_admin

  def new
    @dock = Dock.new
    find_enabled_dock_groups
    dock_groups_length = @dock_groups.length
    if dock_groups_length == 1
      @dock.dock_group_id = @dock_groups.first.id
    end
    respond_to :js
  end

  def create
    @dock = Dock.new(dock_params)
    @dock.update_attributes(:company_id => current_company_id)
    find_enabled_dock_groups
    respond_to :js
  end

  def show
    find_dock
    respond_to :js
  end

  def edit
    find_dock
    find_enabled_dock_groups
    respond_to :js
  end

  def update
    find_dock
    find_enabled_dock_groups
    @dock.update_attributes(dock_params) if !@dock.nil?
    respond_to :js
  end

  def index
    @pagy, @docks = pagy(Dock.where_company_includes_dock_group(current_company_id).order("dock_groups.description asc, docks.number asc"), items:25)
  end

  private
    def dock_params
      params.require(:dock).permit(:number, :dock_group_id, :enabled)
    end

    def find_dock
      @dock = find_object_redirect_invalid(Dock)
    end

    def find_enabled_dock_groups
      @dock_groups = DockGroup.enabled_where_company(current_company_id).order(:description)
    end
end

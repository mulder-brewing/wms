class DocksController < ApplicationController
  before_action :logged_in_admin

  def new
    @dock = Dock.new
    respond_to :js
  end

  def create
    @dock = Dock.new(dock_params)
    @dock.update_attributes(:company_id => current_company_id)
    respond_to :js
  end

  def show
    find_dock
    respond_to :js
  end

  def edit
    find_dock
    respond_to :js
  end

  def update
    find_dock
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
end

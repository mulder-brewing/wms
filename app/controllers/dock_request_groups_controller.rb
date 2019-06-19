class DockRequestGroupsController < ApplicationController
  def index
    @pagy, @dock_request_groups = pagy(DockRequestGroup.where_company(current_company_id).order(:description), items:25)
  end

  def new
    @dock_request_group = DockRequestGroup.new
    respond_to :js
  end

  def create
    @dock_request_group = DockRequestGroup.new(dock_request_group_params)
    @dock_request_group.update_attributes( :company_id => current_company_id)
    respond_to :js
  end

  def edit
    find_dock_request_group
    respond_to :js
  end

  def update
    find_dock_request_group
    @dock_request_group.update_attributes(dock_request_group_params)
    respond_to :js
  end

  private
    def dock_request_group_params
      params.require(:dock_request_group).permit(:description)
    end

    def find_dock_request_group
      @dock_request_group = find_object_redirect_invalid(DockRequestGroup)
    end
end

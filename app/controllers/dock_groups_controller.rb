class DockGroupsController < ApplicationController
  before_action :logged_in_admin

  def new
    @dock_group = DockGroup.new
    respond_to :js
  end

  def create
    @dock_group = DockGroup.new(dock_group_params)
    @dock_group.update_attributes( :company_id => current_company_id)
    respond_to :js
  end

  def show
    find_dock_group
    respond_to :js
  end

  def edit
    find_dock_group
    respond_to :js
  end

  def update
    find_dock_group
    @dock_group.update_attributes(dock_group_params)
    respond_to :js
  end

  def index
    @pagy, @dock_groups = pagy(DockGroup.where_company(current_company_id).order(:description), items:25)
  end

  private
    def dock_group_params
      params.require(:dock_group).permit(:description, :enabled)
    end

    def find_dock_group
      @dock_group = find_object_redirect_invalid(DockGroup)
    end

end

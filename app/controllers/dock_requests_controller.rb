class DockRequestsController < ApplicationController
  include DockRequestsControllerHelper

  def index
    @dock_groups = DockGroup.enabled_where_company(current_company_id).order(:description)
    size = @dock_groups.length
    @show_new = true
    @show_dock_group_selector = true
    if size <= 1
      @show_dock_group_selector = false
    end
    if params[:dock_request].present? && params[:dock_request][:dock_group_id].present?
      stash_dock_group_id(params[:dock_request][:dock_group_id])
    end
    if current_dock_group
      @current_dock_group = current_dock_group
      @dock_requests = DockRequest.where_company_and_group(current_company_id, current_dock_group_id).active.order(:created_at)
    else
      @dock_requests = DockRequest.none
      if size == 0
        flash.now[:danger] = 'You need at least one enabled dock group before you can use the dock queue'
        @show_new = false
      elsif size == 1
        @current_dock_group = @dock_groups.first
        group_id = @current_dock_group.id
        stash_dock_group_id(group_id)
        @dock_requests = DockRequest.where_company_and_group(current_company_id, group_id).active.order(:created_at)
      else
        @show_new = false
      end
    end
    if @current_dock_group
      @docks = Dock.enabled_where_dock_group(@current_dock_group.id)
      docks_length = @docks.length
      if docks_length == 0
        flash.now[:danger] = 'You need at least one enabled dock in this dock group before you can create a new check-in'
        @show_new = false
      end
    end
  end

  def new
    @dock_request = DockRequest.new()
    respond_to :js
  end

  def create
    @dock_request = DockRequest.new(dock_request_params("create"))
    @dock_request.update_attributes( :company_id => current_company_id, :status => "checked_in", :dock_group_id => current_dock_group_id)
    @dock_request.save
    respond_to :js
  end

  def show
    find_dock_request
    respond_to :js
  end

  def edit
    find_dock_request
    respond_to :js
  end

  def update
    find_dock_request
    @dock_request.update_attributes(dock_request_params("update"))
    respond_to :js
  end

  def dock_assignment_edit
    find_dock_request
    @docks = Dock.enabled_where_dock_group(current_dock_group_id)
    respond_to :js
  end

  def dock_assignment_update
    find_dock_request
    @dock_request.context = "dock_assignment"
    @dock_request.update_attributes(dock_request_params("dock_assignment"))
    if !@dock_request.save_success
      @docks = Dock.enabled_where_dock_group(current_dock_group_id)
    end
    respond_to :js
  end

  def unassign_dock
    find_dock_request
    @dock_request.update_attributes(:status => "checked_in", :dock_id => nil)
    respond_to :js
  end

  def check_out
    find_dock_request
    @dock_request.context = "check_out"
    @dock_request.update_attributes(:status => "checked_out")
    respond_to :js
  end

  def history
    @pagy, @dock_requests = pagy(DockRequest.where_company(current_company_id).order(created_at: :desc), items:25)
  end


  private
    def dock_request_params(method)
      if %w(create update).include?(method)
        params.require(:dock_request).permit(:primary_reference, :phone_number, :text_message, :note)
      elsif method == "dock_assignment"
        params.require(:dock_request).permit(:dock_id, :text_message)
      end
    end

    def find_dock_request
      @dock_request = find_object_redirect_invalid(DockRequest)
    end
end

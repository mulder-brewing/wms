class DockRequestsController < ApplicationController
  include DockRequestsControllerHelper

  def index
    if current_dock_group
      @dock_requests = DockRequest.where_company_and_group(current_company_id, current_dock_group_id).order(:created_at)
    else
      @dock_groups = DockGroup.where_company(current_company_id)
      size = @dock_groups.size
      if size == 0
        @dock_requests = DockRequest.none
        @no_dock_groups = true
        flash.now[:danger] = 'You need to setup at least one dock request group before you can use the dock queue'
      elsif size == 1
        group_id = @dock_groups.first.id
        stash_dock_group_id(group_id)
        @dock_requests = DockRequest.where_company_and_group(current_company_id, group_id).order(:created_at)
      else
        @need_to_select_group = true
        @dock_requests = DockRequest.none
      end
    end
  end

  def new
    @dock_request = DockRequest.new
    respond_to :js
  end

  def create
    @dock_request = DockRequest.new(dock_request_params("create"))
    @dock_request.update_attributes( :company_id => current_company_id, :status => "Checked In", :dock_group_id => current_dock_group_id)
    @dock_request.save
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
    respond_to :js
  end

  def dock_assignment_update
    find_dock_request
    @dock_request.context = "dock_assignment"
    @dock_request.update_attributes(dock_request_params("dock_assignment"))
    respond_to :js
  end


  private
    def dock_request_params(method)
      if %w(create update).include?(method)
        params.require(:dock_request).permit(:primary_reference, :phone_number, :text_message, :note)
      elsif method == "dock_assignment"
        params.require(:dock_request).permit(:dock)
      end
    end

    def find_dock_request
      @dock_request = find_object_redirect_invalid(DockRequest)
    end
end

class DockRequestsController < ApplicationController

  def index
    @dock_request_groups = DockRequestGroup.where_company(current_company_id)
    if @dock_request_groups.size == 1
      group = @dock_request_groups
      puts group
      @dock_requests = DockRequest.where_company_and_group(current_company_id, group).order(:created_at)
    end
  end

  def new
    @dock_request = DockRequest.new
    respond_to :js
  end

  def create
    @dock_request = DockRequest.new(dock_request_params("create"))
    @dock_request.update_attributes( :company_id => current_company_id, :status => "Checked In")
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

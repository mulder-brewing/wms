class DockRequestsController < ApplicationController

  def index
    @dock_requests = DockRequest.where_status_not_checked_out(current_company_id).order(:created_at)
  end

  def new
    @dock_request = DockRequest.new
    respond_to :js
  end

  def create
    @dock_request = DockRequest.new(dock_request_params)
    @dock_request.update_attributes( :company_id => current_company_id, :status => "Checked In")
    @dock_request.save
    respond_to :js
  end

  def edit
    @dock_request = find_object_redirect_invalid(DockRequest)
    respond_to :js
  end

  def update
    @dock_request = find_object_redirect_invalid(DockRequest)
    @dock_request.update_attributes(dock_request_params)
    respond_to :js
  end

  private
    def dock_request_params
      params.require(:dock_request).permit(:primary_reference, :phone_number, :text_message, :dock, :note)
    end
end

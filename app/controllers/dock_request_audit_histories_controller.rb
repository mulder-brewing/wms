class DockRequestAuditHistoriesController < ApplicationController
  def index
    find_object_redirect_invalid(DockRequest)
    @dock_request_audit_histories = DockRequestAuditHistory.includes_user_dock_where_dock_request_id(params[:id]).order(:created_at)
    respond_to :js
  end
end

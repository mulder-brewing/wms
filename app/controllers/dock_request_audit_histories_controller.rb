class DockRequestAuditHistoriesController < ApplicationController
  def index
    @dock_request_audit_histories = DockRequestAuditHistory.where_dock_request_id(params[:id]).order(:created_at)
    respond_to :js
  end
end

class DockQueue::DockRequestAuditHistoriesController < ApplicationController
  include TableHelper

  def index
    table = new_table_prep_records(Table::DockRequestAuditHistoriesTable)
    authorize_scope_records(table)
    render locals: { table: table }
  end

end

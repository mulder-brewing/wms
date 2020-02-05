class DockQueue::HistoryDockRequestsController < ApplicationController
  include PageHelper, TableHelper

  def index
    page = new_page(Page::HistoryDockRequestsPage)
    table = new_table_prep_records(Table::DockQueue::HistoryDockRequestsIndexTable)
    authorize_scope_records(table, scope_class: DockQueue::HistoryDockRequestPolicy::Scope)
    page.table = table
    pagy_records(page)
    render_page(page)
  end

end

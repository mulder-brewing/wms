class DockQueue::HistoryDockRequestsController < ApplicationController
  include PageHelper, TableHelper

  def index
    page = new_page(Page::IndexListPage)
    page.show_new_link = false
    page.show_enabled_filter = false
    page.title = "dock_queue/history_dock_requests.title"
    table = new_table_prep_records(Table::DockQueue::HistoryDockRequestsIndexTable)
    authorize_scope_records(table, scope_class: DockQueue::HistoryDockRequestPolicy::Scope)
    page.table = table
    pagy_records(page)
    render_page(page)
  end

end

class Page::HistoryDockRequestsPage < Page::IndexListPage

  def initialize(*)
    super
    @show_new_link = false
    @show_enabled_filter = false
    @title = "dock_queue/history_dock_requests.title"
    @icon_class = "fas fa-history"
  end

end

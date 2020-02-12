class Navbar::NavItem::DropdownItem::DockQueueHistoryItem < Navbar::NavItem::DropdownItem::MainItem

  ID = "navbarDockQueueHistoryItem"

  def initialize(*)
    super(
      id: ID,
      text_key: "dock_queue/history_dock_requests.title",
      path: PathUtil.path(:dock_queue_history_dock_requests_path),
      show: AccessPolicyUtil.check?(:dock_queue)
    )
  end

end

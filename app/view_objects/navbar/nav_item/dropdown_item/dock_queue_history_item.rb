class Navbar::NavItem::DropdownItem::DockQueueHistoryItem < Navbar::NavItem::DropdownItem::MainItem

  def initialize(*)
    super(
      text_key: "dock_queue/history_dock_requests.title",
      path: PathUtil.path(:dock_queue_history_dock_requests_path),
      show: Auth::AccessPolicyUtil.check?(:dock_queue)
    )
  end

end

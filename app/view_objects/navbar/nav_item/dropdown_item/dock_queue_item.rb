class Navbar::NavItem::DropdownItem::DockQueueItem < Navbar::NavItem::DropdownItem::MainItem

  def initialize(*)
    super(
      name: DockQueue::DockRequest.model_name.human(count: 2),
      path: PathUtil.path(:dock_queue_dock_requests_path),
      show: AccessPolicyUtil.check?(:dock_queue)
    )
  end

end

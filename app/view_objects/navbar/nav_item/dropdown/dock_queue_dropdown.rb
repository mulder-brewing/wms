class Navbar::NavItem::Dropdown::DockQueueDropdown < Navbar::NavItem::Dropdown::MainDropdown

  ID = self.name.demodulize

  def initialize(*)
    items = [
      Navbar::NavItem::DropdownItem::DockQueueItem.new,
      Navbar::NavItem::DropdownItem::DockQueueHistoryItem.new
    ]
    super(
      name: DockQueue::DockRequest.model_name.human(count: 2),
      id: ID,
      items: items
    )
  end

end

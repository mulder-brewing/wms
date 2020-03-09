class Navbar::NavItem::Dropdown::DockQueueSubDropdown < Navbar::NavItem::Dropdown::SubDropdown

  def initialize(*)
    items = [
      Navbar::NavItem::DropdownItem::DockGroupsItem.new,
      Navbar::NavItem::DropdownItem::DocksItem.new,
    ]
    super(
      name: DockQueue::DockRequest.model_name.human(count: 2),
      items: items
    )
  end

end

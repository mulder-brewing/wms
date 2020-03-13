class Navbar::NavItem::Dropdown::AdminDropdown < Navbar::NavItem::Dropdown::MainDropdown

  def initialize(*)
    items = [
      Navbar::NavItem::Dropdown::AdminOnlySubDropdown.new,
      Navbar::NavItem::Dropdown::DockQueueSubDropdown.new,
      Navbar::NavItem::DropdownItem::LocationsItem.new,
      Navbar::NavItem::Dropdown::OrderSubDropdown.new,
      Navbar::NavItem::DropdownItem::ShipperProfilesItem.new
    ]
    super(
      text_key: "global.administration",
      items: items
    )
  end

end

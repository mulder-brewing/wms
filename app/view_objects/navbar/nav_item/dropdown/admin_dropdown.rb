class Navbar::NavItem::Dropdown::AdminDropdown < Navbar::NavItem::Dropdown::MainDropdown

  def initialize(*)
    items = [
      Navbar::NavItem::Dropdown::AdminOnlySubDropdown.new,
      Navbar::NavItem::DropdownItem::DockGroupsItem.new,
      Navbar::NavItem::DropdownItem::DocksItem.new
    ]
    super(
      text_key: "global.administration",
      items: items
    )
  end

end

class Navbar::NavItem::Dropdown::OrderSubDropdown < Navbar::NavItem::Dropdown::SubDropdown

  def initialize(*)
    items = [
      Navbar::NavItem::DropdownItem::OrderGroupsItem.new,
    ]
    super(
      text_key: "global.order",
      items: items
    )
  end

end

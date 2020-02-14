class Navbar::NavItem::Dropdown::AdminOnlySubDropdown < Navbar::NavItem::Dropdown::SubDropdown

  def initialize(*)
    items = [
      Navbar::NavItem::DropdownItem::CompaniesItem.new,
      Navbar::NavItem::DropdownItem::UsersItem.new,
      Navbar::NavItem::DropdownItem::AccessPoliciesItem.new
    ]
    super(
      text_key: "global.admin_only",
      items: items
    )
  end

end

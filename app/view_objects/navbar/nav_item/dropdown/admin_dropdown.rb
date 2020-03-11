class Navbar::NavItem::Dropdown::AdminDropdown < Navbar::NavItem::Dropdown::MainDropdown

  def initialize(*)
    items = [
      Navbar::NavItem::Dropdown::AdminOnlySubDropdown.new,
      Navbar::NavItem::Dropdown::DockQueueSubDropdown.new,
      Navbar::NavItem::Dropdown::OrderSubDropdown.new
    ]
    super(
      text_key: "global.administration",
      items: items
    )
  end

end

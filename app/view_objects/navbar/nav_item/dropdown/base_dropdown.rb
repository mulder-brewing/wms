class Navbar::NavItem::Dropdown::BaseDropdown < Navbar::NavItem::BaseNavItem

  attr_accessor :items

  def initialize(**options)
    super
    @items = options[:items] || []
  end

  def show?
    items.any?{ |item| item.show? }
  end

end

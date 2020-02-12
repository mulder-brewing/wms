class Navbar::MainNavbar < Navbar::BaseNavbar

  attr_accessor :roots

  def initialize(**options)
    super
    @roots = [
      Navbar::NavItem::Dropdown::DockQueueDropdown.new
    ]
  end
end

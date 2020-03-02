class Navbar::MainNavbar < Navbar::BaseNavbar

  attr_accessor :log_out_button

  def initialize(**options)
    super(
      class: "fixed-top navbar-dark bg-dark",
      toggler_id: "navbarToggler"
    )
    @log_out_button = Button::LogOutButton.new
  end

  def roots
    [
      Navbar::NavItem::Dropdown::DockQueueDropdown.new,
      Navbar::NavItem::Dropdown::AdminDropdown.new
    ]
  end
end

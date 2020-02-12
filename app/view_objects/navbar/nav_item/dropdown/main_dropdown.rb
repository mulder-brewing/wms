class Navbar::NavItem::Dropdown::MainDropdown < Navbar::NavItem::Dropdown::BaseDropdown

  HTML_OPTIONS = {
    :class => "nav-link dropdown-toggle",
    :role => "button",
    :'data-toggle' => "dropdown",
    :'aria-haspopup' => "true",
    :'aria-expanded' => "false"
  }

  def path
    "#"
  end

end

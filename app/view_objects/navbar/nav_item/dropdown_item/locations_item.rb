class Navbar::NavItem::DropdownItem::LocationsItem < Navbar::NavItem::DropdownItem::MainItem

  def initialize(*)
    super(
      name: Location.model_name.human(count: 2),
      path: PathUtil.path(:locations_path, enabled: true),
      show: Auth::AccessPolicyUtil.check?(:locations)
    )
  end

end

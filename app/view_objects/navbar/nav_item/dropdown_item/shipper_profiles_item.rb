class Navbar::NavItem::DropdownItem::ShipperProfilesItem < Navbar::NavItem::DropdownItem::MainItem

  def initialize(*)
    super(
      name: ShipperProfile.model_name.human(count: 2),
      path: PathUtil.path(:shipper_profiles_path, enabled: true),
      show: Auth::AccessPolicyUtil.check?(:shipper_profiles)
    )
  end

end

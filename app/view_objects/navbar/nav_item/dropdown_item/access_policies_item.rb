class Navbar::NavItem::DropdownItem::AccessPoliciesItem < Navbar::NavItem::DropdownItem::MainItem

  def initialize(*)
    super(
      name: AccessPolicy.model_name.human(count: 2),
      path: PathUtil.path(:access_policies_path, enabled: true),
      show: UserUtil.admin?
    )
  end

end

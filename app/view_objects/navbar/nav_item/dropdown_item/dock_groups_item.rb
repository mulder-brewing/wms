class Navbar::NavItem::DropdownItem::DockGroupsItem < Navbar::NavItem::DropdownItem::MainItem

  def initialize(*)
    super(
      name: DockGroup.model_name.human(count: 2),
      path: PathUtil.path(:dock_groups_path, enabled: true),
      show: AccessPolicyUtil.check?(:dock_groups)
    )
  end

end

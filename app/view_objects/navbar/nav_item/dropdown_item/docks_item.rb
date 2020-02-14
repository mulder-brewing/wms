class Navbar::NavItem::DropdownItem::DocksItem < Navbar::NavItem::DropdownItem::MainItem

  def initialize(*)
    super(
      name: Dock.model_name.human(count: 2),
      path: PathUtil.path(:docks_path, enabled: true),
      show: AccessPolicyUtil.check?(:docks)
    )
  end

end

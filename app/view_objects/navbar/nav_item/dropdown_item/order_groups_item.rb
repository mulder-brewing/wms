class Navbar::NavItem::DropdownItem::OrderGroupsItem < Navbar::NavItem::DropdownItem::MainItem

  def initialize(*)
    super(
      name: Order::OrderGroup.model_name.human(count: 2),
      path: PathUtil.path(:order_order_groups_path, enabled: true),
      show: Auth::AccessPolicyUtil.check?(:order_order_groups)
    )
  end

end

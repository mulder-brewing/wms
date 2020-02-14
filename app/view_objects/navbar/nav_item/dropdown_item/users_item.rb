class Navbar::NavItem::DropdownItem::UsersItem < Navbar::NavItem::DropdownItem::MainItem

  def initialize(*)
    super(
      name: Auth::User.model_name.human(count: 2),
      path: PathUtil.path(:auth_users_path, enabled: true),
      show: UserUtil.admin?
    )
  end

end

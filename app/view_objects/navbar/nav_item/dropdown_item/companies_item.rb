class Navbar::NavItem::DropdownItem::CompaniesItem < Navbar::NavItem::DropdownItem::MainItem

  def initialize(*)
    super(
      name: Company.model_name.human(count: 2),
      path: PathUtil.path(:companies_path, enabled: true),
      show: UserUtil.app_admin?
    )
  end

end

class Page::Auth::UsersIndexPage < Page::IndexListPage

  def initialize(*)
    super
    @table = Table::Auth::UsersIndexTable.new(@current_user)
  end
end

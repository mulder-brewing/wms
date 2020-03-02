class PaginationVisible < VisibleTO

  def initialize(*)
    super
    @selector = "main div.pagination-wrapper"
  end

end

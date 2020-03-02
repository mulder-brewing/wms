class EnabledFilterVisible < ActionBarVisible

  def initialize(*)
    super
    @class = "enabled-filter"
  end
end

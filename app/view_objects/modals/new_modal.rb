class Modals::NewModal < Modals::NewCreateModal

  def initialize(*)
    super
    @persist = false
  end

end

class Modals::CreateModal < Modals::NewCreateModal

  def initialize(form)
    super
    @persist = true
  end

end

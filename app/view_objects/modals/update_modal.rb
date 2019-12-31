class Modals::UpdateModal < Modals::EditUpdateModal

  def initialize(form)
    super
    @persist = true
  end

end

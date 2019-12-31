class Modals::EditModal < Modals::EditUpdateModal

  def initialize(*)
    super
    @persist = false
  end

end

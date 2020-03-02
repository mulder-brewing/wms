class Modal::UpdateModal < Modal::EditUpdateModal

  def initialize(*)
    super
    @persist = true
  end

end

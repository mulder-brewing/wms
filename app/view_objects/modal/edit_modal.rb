class Modal::EditModal < Modal::EditUpdateModal

  def initialize(*)
    super
    @persist = false
  end

end

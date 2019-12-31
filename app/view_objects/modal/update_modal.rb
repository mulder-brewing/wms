class Modal::UpdateModal < Modal::EditUpdateModal

  def initialize(form)
    super
    @persist = true
  end

end

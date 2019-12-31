class Modal::NewModal < Modal::NewCreateModal

  def initialize(*)
    super
    @persist = false
  end

end

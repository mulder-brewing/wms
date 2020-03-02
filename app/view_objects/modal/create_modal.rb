class Modal::CreateModal < Modal::NewCreateModal

  def initialize(*)
    super
    @persist = true
  end

end

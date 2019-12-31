class Modal::CreateModal < Modal::NewCreateModal

  def initialize(form)
    super
    @persist = true
  end

end

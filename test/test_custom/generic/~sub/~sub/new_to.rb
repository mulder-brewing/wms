class NewTO < ModalTO

  def initialize(*)
    super
    @action = :new
  end

  def modal_path
    PathUtil.new(model)
  end

end

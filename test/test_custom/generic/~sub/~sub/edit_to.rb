class EditTO < ModalTO
  include Includes::NotFound

  def initialize(*)
    super
    @action = :edit
  end

  def modal_path
    PathUtil.edit(model)
  end

  def controller_action_path
    super(id: model.id)
  end

end

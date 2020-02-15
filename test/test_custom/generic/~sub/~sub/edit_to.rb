class EditTO < ModalTO
  include Includes::NotFound

  def path
    @path || PathUtil.edit(@model)
  end

end

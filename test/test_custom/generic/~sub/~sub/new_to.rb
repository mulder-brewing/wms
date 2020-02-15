class NewTO < ModalTO

  def path
    @path || PathUtil.new(@model)
  end

end

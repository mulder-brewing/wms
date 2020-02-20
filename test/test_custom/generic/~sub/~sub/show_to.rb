class ShowTO < ModalTO
  include Includes::NotFound

  def modal_path
    PathUtil.record(model)
  end

end

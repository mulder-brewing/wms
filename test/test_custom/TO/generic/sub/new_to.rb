class NewTO < GenericTO

  def new_path
    new_polymorphic_path(@model)
  end

end

class DestroyTO < GenericTO

  def test(test)
    test.destroy_to_test(self)
  end

  def path
    @path || Rails.application.routes.url_helpers.polymorphic_path(@model)
  end

end

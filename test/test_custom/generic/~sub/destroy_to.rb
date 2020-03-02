class DestroyTO < GenericTO

  def initialize(*)
    super
    @action = :destroy
  end

  def test(test)
    test.destroy_to_test(self)
  end

  def path
    @path || Rails.application.routes.url_helpers.polymorphic_path(@model)
  end

end

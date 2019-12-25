class UpdateTO < CreateUpdateTO
  include Includes::NotFound

  attr_accessor :update_fields

  def test(test)
    test.update_to_test(self)
  end

  def update_path
    @path ||= Rails.application.routes.url_helpers.polymorphic_path(@model)
  end

end

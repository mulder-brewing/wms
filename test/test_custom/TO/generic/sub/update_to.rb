class UpdateTO < CreateUpdateTO
  include NotFound

  attr_accessor :update_fields

  def test(test)
    test.update_to_test(self)
  end

  def update_path
    polymorphic_path(@model)
  end

end

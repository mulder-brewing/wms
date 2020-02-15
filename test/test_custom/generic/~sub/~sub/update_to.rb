class UpdateTO < CreateUpdateTO
  include Includes::NotFound

  attr_accessor :update_fields

  def test(test)
    test.update_to_test(self)
  end

end

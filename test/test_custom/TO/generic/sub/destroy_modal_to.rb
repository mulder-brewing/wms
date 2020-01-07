class DestroyModalTO < GenericTO
  include Includes::Title

  attr_accessor :to_delete

  def test(test)
    test.destroy_modal_to_test(self)
  end

end

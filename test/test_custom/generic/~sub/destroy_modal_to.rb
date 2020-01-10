class DestroyModalTO < GenericTO

  def initialize(*)
    super
    @select_jquery_method = :select_modal
  end

  def test(test)
    test.destroy_modal_to_test(self)
  end

end

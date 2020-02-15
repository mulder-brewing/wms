class ModalTO < GenericTO

  attr_accessor :timestamps_visible

  def initialize(*)
    super
    @select_jquery_method = :select_modal
  end

  def test(test)
    test.basic_modal_to_test(self)
  end

  def test_timestamps?
    !@timestamps_visible.nil?
  end

end

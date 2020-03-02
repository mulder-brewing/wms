class ModalTO < GenericTO

  def initialize(*)
    super
    @select_jquery_method = :select_modal
  end

  def test(test)
    test.basic_modal_to_test(self)
  end

  def path
    @path || controller_action_path || modal_path
  end

  def modal_path; end

end

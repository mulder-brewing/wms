class NewEditTO < GenericTO

  attr_accessor :timestamps_visible

  def initialize(*)
    super
    @select_jquery_method = :select_modal
  end

  def test_timestamps?
    !@timestamps_visible.nil?
  end

end

class NewEditTO < GenericTO
  include Includes::Title
  include Includes::Inputs

  attr_accessor :timestamps_visible

  def initialize(user, model, validity)
    @select_jquery_method = "select_modal"
    super
  end

  def add_save_button
    @buttons ||= []
    @buttons << :save
  end

  def check_save_button?
    buttons.include? :save
  end

  def add_close_button
    @buttons ||= []
    @buttons << :close
  end

  def check_close_button?
    buttons.include? :close
  end

  def buttons
    @buttons ||= []
  end

  def test_buttons?
    !@buttons.blank?
  end

  def test_timestamps?
    !@timestamps_visible.nil?
  end

end

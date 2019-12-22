class NewEditTO < GenericTO
  include Includes::Title

  ENABLED_REGEX = /#{I18n.t("global.boolean.enabled_disabled.enabled")}/

  attr_accessor :timestamps_visible, :inputs
  attr_writer :test_enabled, :enabled_present

  def test_enabled?
    @test_enabled
  end

  def enabled_regex
    ENABLED_REGEX
  end

  def test_buttons?
    @test_buttons
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

  def add_input(input)
    @inputs ||= []
    @inputs << input
  end

  def test_inputs?
    !@inputs.blank?
  end

end

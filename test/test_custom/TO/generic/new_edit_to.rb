class NewEditTO < GenericTO

  ENABLED_REGEX = /#{I18n.t("global.boolean.enabled_disabled.enabled")}/

  attr_writer :test_enabled, :enabled_present

  def test_enabled?
    @test_enabled
  end

  def enabled_regex
    ENABLED_REGEX
  end

end

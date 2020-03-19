module GeographyUtil

  def self.country_valid?(country_code)
    Geography::COUNTRIES.key?(country_code)
  end

  def self.state_valid?(country_code, state_code)
    !!Geography::COUNTRIES_STATES.dig(country_code, state_code)
  end
end

module Util::String

  class DigitsOnly < ApplicationService
    def initialize(string)
      @string = string
    end

    def call
      return @string.to_s.scan(/\d/).join('')
    end
  end

end

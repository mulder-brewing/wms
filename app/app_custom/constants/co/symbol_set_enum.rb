require 'set'

class Constants::CO::SymbolSetEnum

  attr_reader :value

  def initialize(value, values)
    raise "value must be a symbol" unless value.is_a? Symbol
    raise "values must all be symbols" unless values.all? { |v| v.is_a? Symbol }
    raise "value is not valid" unless values.include?(value)
    @value = value

    values.each do |v|
      self.class.send(:define_method, "#{v.to_s}?") do
        @value == v
      end
    end
  end

  def value_to_s
    @value.to_s
  end
end

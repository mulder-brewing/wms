class Show::Attribute::RecordAttribute < Show::Attribute::BaseAttribute

  attr_accessor :label, :value

  def initialize(**options)
    @label = options[:label]
    @value = options[:value]
  end

end

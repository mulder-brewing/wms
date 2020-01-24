class Show::RecordShow < Show::BaseShow

  RA = Show::Attribute::RecordAttribute

  attr_accessor :record, :attributes, :label_col_width

  def initialize(**options)
    @record = options[:record]
    @attributes = []
    @label_col_width = 5
  end

  def han(attribute)
    @record.human_attribute_name(attribute)
  end

end

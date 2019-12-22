class ErrorTO

  attr_accessor :type, :field, :error

  def initialize(type, field)
    @type = type
    @field = field
  end

  def error_message
    field_human = @field.to_s.humanize
    f = Proc.new {|x| /#{ field_human + " " + I18n.t(x) }/ }
    case @type
    when :unique
      f.call("form.errors.taken")
    when :does_not_belong
      f.call("form.errors.does_not_belong")
    end
  end
end

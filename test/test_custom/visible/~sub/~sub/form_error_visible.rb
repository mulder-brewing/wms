class FormErrorVisible < FormVisible

  attr_accessor :type, :error

  def initialize(*)
    super
    @class = "invalid-feedback"
    @text = error_message(@type, @error, @field)
  end

  private

  def error_message(type, error, field)
    raise ArgumentError unless (type.is_a?(Symbol) || error.is_a?(String))
    field_human = field.to_s.humanize
    f = Proc.new {|x| /#{ field_human + " " + I18n.t(x) }/ }
    return f.call(error) if error.is_a?(String)
    case type
    when :invalid
      f.call("form.errors.invalid")
    when :unique
      f.call("form.errors.taken")
    when :does_not_belong
      f.call("form.errors.does_not_belong")
    when :same
      f.call("form.errors.same")
    when :disabled_self
      f.call("form.errors.disabled_self")
    end
  end

end

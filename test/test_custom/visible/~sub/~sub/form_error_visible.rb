class FormErrorVisible < FormVisible

  attr_accessor :type, :error

  def initialize(*)
    super
    @text = error_message(@type, @error, @field)
  end

  private

  def error_message(type, error, field)
    raise ArgumentError unless (type.is_a?(Symbol) || error.is_a?(String))
    field_human = field.to_s.titleize
    f = Proc.new {|x| /#{ field_human + " " + I18n.t(x) }/i }
    return f.call(error) if error.is_a?(String)
    case type
    when :invalid
      f.call("errors.messages.invalid")
    when :unique
      f.call("errors.messages.taken")
    when :exist
      f.call("errors.messages.exist")
    when :blank
      f.call("errors.messages.blank")
    when :does_not_belong
      f.call("activerecord.errors.messages.does_not_belong")
    when :same
      f.call("activemodel.errors.models.auth/password_reset.same")
    when :disabled_self
      f.call("activemodel.errors.models.auth/user.disabled_self")
    end
  end

end

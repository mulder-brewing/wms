class FormFieldErrorVisible < FormErrorVisible

  def initialize(*)
    super
    @class = "invalid-feedback"
  end

end

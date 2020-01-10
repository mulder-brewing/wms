class FormFieldVisible < FormVisible

  attr_accessor :form, :field

  def initialize(*)
    super
    @id ||= form_input_id(@form, @field)
  end

  def form_input_id(form, field)
    form.record_name + "_" + field.to_s
  end

end

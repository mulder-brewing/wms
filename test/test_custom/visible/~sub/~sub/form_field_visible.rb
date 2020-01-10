class FormFieldVisible < FormVisible

  def initialize(*)
    super
    @id ||= form_input_id(@form, @field)
  end

  def form_input_id(form, field)
    form.record_name + "_" + field.to_s
  end

end

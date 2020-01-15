module FormHelper

  private

  def new_form(form_class)
    return form_class.new(current_user, self)
  end

  def new_form_prep_record(form_class)
    form = new_form(form_class)
    form.prep_record(params)
    return form
  end

  def assign_form_attributes(form)
    form.attributes = params.require(form.record_name).permit(form.permitted_params)
  end

end

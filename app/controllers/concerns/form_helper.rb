module FormHelper

  def new_form(form_class)
    return form_class.new(current_user, self)
  end

  def new_form_prep_record(form_class)
    form = new_form(form_class)
    form.prep_record(params)
    return form
  end

end

module ModalHelper

  def new_modal(form_class)
    form = new_form(form_class)
    form.prep_record(params)
    assign_form_attributes(form)
    authorize form.record
    form.setup_variables
    modal = modal_class.new(form)
    modal.table = form.table
    return modal
  end

  def new_form(form_class)
    return form_class.new(current_user, self)
  end

  def render_modal(modal)
    respond_to do |format|
      format.js {
        render  :template => modal.render_path,
                :locals => { modal: modal }
      }
    end
  end

  def modal_class
    case action_sym
    when :new
      Modal::NewModal
    when :create
      Modal::CreateModal
    when :edit
      Modal::EditModal
    when :update
      Modal::UpdateModal
    end
  end

  def assign_form_attributes(form)
    if params.has_key?(form.record_name)
      form.attributes = params.require(form.record_name).permit(form.permitted_params)
    end
  end

end

module ModalHelper

  def new_modal(form_class)
    form = new_form(form_class)
    form.prep_record(params)
    authorize form.record
    modal = modal_class.new(form)
    return modal
  end

  def new_form(form_class)
    return form_class.new(current_user, self)
  end

  def render_modal(modal)
    if self.respond_to?(:table_array_hash, true)
      modal.table = Table::GenericTable.new(table_array_hash)
    end
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

end

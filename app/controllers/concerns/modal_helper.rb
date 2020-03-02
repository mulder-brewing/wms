module ModalHelper

  def render_modal(modal)
    respond_to do |format|
      format.js {
        render  :template => modal.render_path,
                :locals => { modal: modal }
      }
    end
  end
  
end

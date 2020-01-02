module PageHelper

  def render_page(page, pagy)
    respond_to do |format|
      format.html {
        render  :template => page.render_path,
                :locals => {  page: page,
                              pagy: pagy
                }
      }
    end
  end

end

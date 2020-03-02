module PageHelper

  def new_page(page_class)
    return page_class.new(current_user, self)
  end

  def prep_new_page(page_class)
    page = new_page(page_class)
    page.prep(params)
    return page
  end

  def pagy_records(page)
    page.pagy, page.table.records = pagy(page.table.records, items:25)
  end

  def render_page(page)
    respond_to do |format|
      format.html {
        render  :template => page.render_path,
                :locals => { page: page }
      }
    end
  end

end

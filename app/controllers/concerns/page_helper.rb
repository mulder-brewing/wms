module PageHelper

  def new_page(page_class)
    return page_class.new(current_user, self)
  end

  def new_page_prep_records(page_class)
    page = new_page(page_class)
    page.prep_records(params)
    return page
  end

  def authorize_records(page)
    authorize page.records
  end

  def scope_records(page)
    page.records = policy_scope(page.records)
  end

  def authorize_scope_records(page)
    authorize_records(page)
    page.records = policy_scope(page.records)
  end

  def pagy_records(page)
    page.pagy, page.records = pagy(page.records, items:25)
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

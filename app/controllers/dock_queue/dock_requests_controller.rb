class DockQueue::DockRequestsController < ApplicationController
  include FormHelper, ModalHelper, PageHelper

  def new
    form = new_form_prep_record(DockQueue::DockRequestForm)
    authorize form.record
    modal = Modal::NewModal.new(form)
    render_modal(modal)
  end

  def create
    form = new_form_prep_record(DockQueue::DockRequestForm)
    assign_form_attributes(form)
    authorize form.record
    form.submit
    modal = Modal::CreateModal.new(form, page: form.page, table: form.table)
    render_modal(modal)
  end

  def edit
    form = new_form_prep_record(DockQueue::DockRequestForm)
    authorize form.record
    modal = Modal::EditModal.new(form)
    render_modal(modal)
  end

  def update
    form = new_form_prep_record(DockQueue::DockRequestForm)
    assign_form_attributes(form)
    authorize form.record
    form.submit
    modal = Modal::UpdateModal.new(form, page: form.page, table: form.table)
    render_modal(modal)
  end

  def show
    form = new_form_prep_record(DockQueue::DockRequestForm)
    authorize form.record
    modal = Modal::ShowModal.new(form, show: Show::DockRequestShow.new(record: form.record))
    render_modal(modal)
  end

  def index
    page = new_page_prep_records(Page::DockRequestsPage)
    page.table = Table::DockRequestsIndexTable.new(current_user)
    authorize_scope_records(page)
    case page.dock_groups_count
    when 0
      flash.now[:danger] = I18n.t("dock_requests.no_dg_msg")
    when 1
      if page.dock_group_nil?
        redirect_to dock_requests_url(dock_request: { dock_group_id: page.dock_groups.first.id }) and return
      end
    end
    render_page(page)
  end

  def dock_assignment_edit
    find_dock_request
    if not_nil?
      @docks = Dock.enabled_where_dock_group(@dock_request.dock_group_id)
      @dock_request.number_of_enabled_docks_within_dock_group = @docks.length
    end
    set_context("dock_assignment_edit")
    respond_to :js
  end

  def dock_assignment_update
    find_dock_request
    set_context("dock_assignment_update")
    update_dock_request_with_params("dock_assignment_update")
    if not_nil? && !@dock_request.save_success
      @docks = Dock.enabled_where_dock_group(@dock_request.dock_group_id)
    end
    respond_to :js
  end

  def unassign_dock
    find_dock_request
    update_dock_request_with_context("dock_unassign")
    respond_to :js
  end

  def check_out
    find_dock_request
    update_dock_request_with_context("check_out")
    respond_to :js
  end

  def void
    find_dock_request
    update_dock_request_with_context("void")
    respond_to :js
  end

  def history
    @pagy, @dock_requests = pagy(DockRequest.where_company(current_company_id).order(created_at: :desc), items:25)
  end

  private
    def dock_request_params(method)
      if %w(create update).include?(method)
        params.require(:dock_request).permit(:primary_reference, :phone_number, :text_message, :note, :dock_group_id)
      elsif method == "dock_assignment_update"
        params.require(:dock_request).permit(:dock_id, :text_message)
      end
    end

    def update_dock_request_with_params(method)
      @dock_request.update(dock_request_params(method)) if not_nil?
    end

    def update_dock_request_with_context(context)
      @dock_request.update(:context => context) if not_nil?
    end

    def set_context(context)
      @dock_request.context = context if not_nil?
    end

    def not_nil?
      !@dock_request.nil?
    end

    def find_dock_request
      @dock_request = find_object_redirect_invalid(DockRequest)
    end

    def find_current_dock_group
      @current_dock_group = current_dock_group
    end

    def find_dock_group_redirect_invalid(id)
      dock_group = @dock_groups.find { |d| d.id == id.to_i }
      all_formats_redirect_to(root_url) if dock_group.nil?
    end



end

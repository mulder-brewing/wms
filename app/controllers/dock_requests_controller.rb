class DockRequestsController < ApplicationController
  include DockRequestsControllerHelper

  def index
    @dock_groups = DockGroup.enabled_where_company(current_company_id).order(:description)
    size = @dock_groups.length
    @show_new = true
    @show_dock_group_selector = true
    if size <= 1
      @show_dock_group_selector = false
    end
    if params[:dock_request].present? && params[:dock_request][:dock_group_id].present?
      params_group_id = params[:dock_request][:dock_group_id]
      find_dock_group_redirect_invalid(params_group_id)
      stash_dock_group_id(params_group_id)
    elsif current_dock_group
      redirect_to dock_requests_url(dock_request: { dock_group_id: current_dock_group_id })
    end
    if current_dock_group
      @current_dock_group = current_dock_group
      @dock_requests = DockRequest.where_company_and_group(current_company_id, current_dock_group_id).include_docks.active.order(:created_at)
    else
      @dock_requests = DockRequest.none
      if size == 0
        flash.now[:danger] = 'You need at least one enabled dock group before you can use the dock queue'
        @show_new = false
      elsif size == 1
        redirect_to dock_requests_url(dock_request: { dock_group_id: @dock_groups.first.id })
      else
        @show_new = false
      end
    end
  end

  def new
    @dock_request = DockRequest.new()
    find_current_dock_group
    respond_to :js
  end

  def create
    @dock_request = DockRequest.new(dock_request_params("create"))
    @dock_request.update_attributes(:company_id => current_company_id)
    respond_to :js
  end

  def show
    find_dock_request
    respond_to :js
  end

  def edit
    find_dock_request
    set_context("edit")
    respond_to :js
  end

  def update
    find_dock_request
    set_context("update")
    update_dock_request_with_params("update")
    respond_to :js
  end

  def dock_assignment_edit
    find_dock_request
    if !@dock_request.nil?
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
    if !@dock_request.nil? && !@dock_request.save_success
      @docks = Dock.enabled_where_dock_group(@dock_request.dock_group_id)
    end
    respond_to :js
  end

  def unassign_dock
    find_dock_request
    @dock_request.update_attributes(:context => "dock_unassign")
    respond_to :js
  end

  def check_out
    find_dock_request
    @dock_request.update_attributes(:context => "check_out")
    respond_to :js
  end

  def void
    find_dock_request
    @dock_request.update_attributes(:context => "void")
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
      if !@dock_request.nil?
        @dock_request.update_attributes(dock_request_params(method))
      end
    end

    def find_dock_request
      @dock_request = find_object_redirect_invalid(DockRequest)
    end

    def find_current_dock_group
      @current_dock_group = current_dock_group
    end

    def find_current_dock_group_docks
      @current_dock_group_docks = current_dock_group_docks
    end

    def find_current_dock_group_with_docks
      find_current_dock_group
      find_current_dock_group_docks
    end

    def find_dock_group_redirect_invalid(id)
      dock_group = @dock_groups.find { |d| d.id == id.to_i }
      all_formats_redirect_to(root_url) if dock_group.nil?
    end

    def set_context(context)
      @dock_request.context = context if !@dock_request.nil?
    end

end

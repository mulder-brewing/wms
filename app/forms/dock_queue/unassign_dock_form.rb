class DockQueue::UnassignDockForm < DockAssignmentForm

  validate :status_is_dock_assigned

  delegate  :dock_id, :dock_id=,
            :text_message, :text_message=,
            :status, :status=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "DockQueue::DockAssignment")
  end

  def initialize(*)
    super
    @table_class = Table::DockRequestsIndexTable
    @page_class = Page::DockRequestsPage
  end

  def prep_record(params)
    @record = DockQueue::DockRequest.find(params[:id])
  end

  def submit
    record.status = "dock_assigned"
    record.dock_assigned_at = DateTime.now
    super
  end

  def setup_variables
    @docks = Dock.enabled_where_dock_group(record.dock_group_id)
  end

  def permitted_params
    [:dock_id, :text_message]
  end

  def show_phone_number?
    !record.phone_number.blank?
  end

  private

  def status_is_checked_in
    unless record.status_was == "checked_in"
      errors.add(:status, :no_longer_checked_in)
    end
  end

end

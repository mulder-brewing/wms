class DockQueue::AssignDockForm < DockQueue::DockAssignmentForm

  validates :dock_id, presence: true

  attr_accessor :docks

  delegate  :dock_id, :dock_id=,
            :text_message, :text_message=,
            to: :@record

  def initialize(*)
    super
    @valid_status_before_change << "checked_in"
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

  def private_submit
    record.status = "dock_assigned"
    record.dock_assigned_at = DateTime.now
    super
  end

  def audit
    create_audit_history_entry(event: "dock_assigned", dock_id: record.dock_id)
    if record.text_message
      create_audit_history_entry(event: "text_message_sent",
        phone_number: record.phone_number)
    end
  end

end

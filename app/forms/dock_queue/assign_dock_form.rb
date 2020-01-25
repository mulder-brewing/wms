class DockQueue::AssignDockForm < DockQueue::DockAssignmentForm

  validates :dock_id, presence: true
  validate :status_is_checked_in

  attr_accessor :docks

  delegate  :dock_id, :dock_id=,
            :text_message, :text_message=,
            to: :@record

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

  def error_check_modal(modal)
    unless record.status_checked_in?
      modal.error = true
      modal.error_msg = error_msg_for_status(record.status)
      modal.error_js_path = error_js_path
    end
  end

  private

  def status_is_checked_in
    unless record.status_was == "checked_in"
      errors.add(:status, :no_longer_checked_in)
    end
  end

  def error_msg_for_status(status)
    I18n.t("dock_queue/dock_assignments.error." << status)
  end

end

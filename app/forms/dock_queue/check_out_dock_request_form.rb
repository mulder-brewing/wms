class DockQueue::CheckOutDockRequestForm < DockQueue::StatusChangeForm

  def initialize(*)
    super
    @valid_status_before_change << "dock_assigned"
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, "DockQueue::CheckOutDockRequest")
  end

  def check_out_msg
    I18n.t("dock_queue/check_out_dock_requests.check_out_msg",
      :target=> record.primary_reference, :time=> record.total_time)
  end

  private

  def private_submit
    record.status = "checked_out"
    record.checked_out_at = DateTime.now
    super
  end

  def audit
    create_audit_history_entry(event: "checked_out")
  end

end

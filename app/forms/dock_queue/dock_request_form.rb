class DockQueue::DockRequestForm < DockQueue::BaseDockQueueForm

  validate :phone_number_if_text_message

  delegate  :primary_reference, :primary_reference=,
            :phone_number, :phone_number=,
            :text_message, :text_message=,
            :note, :note=,
            :dock_group_id, :dock_group_id=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "DockQueue::DockRequest")
  end

  def initialize(*)
    super
    @valid_status_before_change.push("checked_in", "dock_assigned")
  end

  def prep_record(params)
    super(params)
    unless params.has_key?(:id)
      @record.dock_group_id = params[:dock_group_id]
    end
  end

  def permitted_params
    [:primary_reference, :phone_number, :text_message, :note, :dock_group_id]
  end

  private

  def audit
    event = nil
    if action?(:create)
      event = "checked_in"
    elsif action?(:update) && record.saved_changes?
      event = "updated"
    end
    unless event.nil?
      create_audit_history_entry(event: event)
    end
  end

  def phone_number_if_text_message
    if text_message && phone_number.blank?
      errors.add(:phone_number, :blank_send_sms)
    end
  end

end

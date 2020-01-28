class DockQueue::VoidDockRequestForm < DockQueue::StatusChangeForm

  def self.model_name
    ActiveModel::Name.new(self, nil, "DockQueue::VoidDockRequest")
  end

  def initialize(*)
    super
    @valid_status_before_change << "checked_in"
  end

  def view_path
    nil
  end

  private

  def private_submit
    record.status = "voided"
    record.voided_at = DateTime.now
    super
  end

end

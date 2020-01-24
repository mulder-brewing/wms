class DockQueue::DockAssignmentForm < BasicRecordForm

  attr_accessor :docks

  delegate  :dock_id, :dock_id=,
            :text_message, :text_message=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "DockQueue::DockAssignment")
  end

  def prep_record(params)
    @record = DockQueue::DockRequest.find(params[:id])
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

end

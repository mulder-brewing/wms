class DockQueue::DockAssignmentForm < DockQueue::StatusChangeForm

  def self.model_name
    ActiveModel::Name.new(self, nil, "DockQueue::DockAssignment")
  end

end

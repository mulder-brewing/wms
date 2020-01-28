class DockQueue::StatusChangeForm < DockQueue::BaseDockQueueForm

  def prep_record(params)
    @record = DockQueue::DockRequest.find(params[:id])
  end

end

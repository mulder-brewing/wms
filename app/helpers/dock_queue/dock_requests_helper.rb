module DockQueue::DockRequestsHelper

  def dock_number(record)
    t("dock_queue/dock_requests.dock_number", number: record.dock.number)
  end

end

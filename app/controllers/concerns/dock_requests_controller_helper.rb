module DockRequestsControllerHelper
  # Stores the user's dock request group id in sessions
  def stash_dock_group_id(group_id)
    session[:dock_group_id] = group_id
  end

  # Returns the current user's dock request group (if any).
  def current_dock_group
    if session[:dock_group_id]
      @dock_group ||= DockGroup.find_by(id: session[:dock_group_id])
    end
  end

  # Returns the current user's dock request group (if any).
  def current_dock_group_id
    current_dock_group.id
  end

  def clear_dock_group
    session.delete(:dock_group_id)
    @dock_group = nil
  end
end

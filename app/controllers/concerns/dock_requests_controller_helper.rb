module DockRequestsControllerHelper
  # Stores the user's dock request group id in sessions
  def stash_dock_group_id(group_id)
    session[:dock_group_id] = group_id
  end

  # Returns the current user's dock request group (if any).
  def current_dock_group
    session_dock_group = session[:dock_group_id]
    if session_dock_group
      group_id = session_dock_group.to_i
      if @dock_groups
        @dock_group ||= @dock_groups.find { |d| d.id == group_id }
      else
        @dock_group ||= DockGroup.find_by(id: group_id)
      end
    end
  end

  # Returns the current user's dock request group (if any).
  def current_dock_group_id
    current_dock_group.id if current_dock_group
  end

  def current_dock_group_docks
    if current_dock_group
      Dock.enabled_where_dock_group(current_dock_group_id)
    end
  end


  def clear_dock_group
    session.delete(:dock_group_id)
    @dock_group = nil
  end
end

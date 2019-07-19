class AddEnabledToDockGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :dock_groups, :enabled, :boolean, default: true
  end
end

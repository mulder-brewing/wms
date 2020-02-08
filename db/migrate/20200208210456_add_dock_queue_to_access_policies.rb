class AddDockQueueToAccessPolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :access_policies, :dock_queue, :boolean
  end
end

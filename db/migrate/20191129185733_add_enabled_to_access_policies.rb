class AddEnabledToAccessPolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :access_policies, :enabled, :boolean, default: true
  end
end

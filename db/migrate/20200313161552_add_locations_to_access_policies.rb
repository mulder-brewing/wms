class AddLocationsToAccessPolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :access_policies, :locations, :boolean
  end
end

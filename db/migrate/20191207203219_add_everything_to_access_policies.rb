class AddEverythingToAccessPolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :access_policies, :everything, :boolean
  end
end

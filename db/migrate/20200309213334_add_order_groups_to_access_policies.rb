class AddOrderGroupsToAccessPolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :access_policies, :order_groups, :boolean
  end
end

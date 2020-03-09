class ChangeOrderGroupsPermissionColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :access_policies, :order_groups, :order_order_groups
  end
end

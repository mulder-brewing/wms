class CreateDockRequestGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :dock_request_groups do |t|
      t.text :description

      t.timestamps
    end
  end
end

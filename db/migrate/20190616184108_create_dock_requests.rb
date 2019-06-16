class CreateDockRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :dock_requests do |t|
      t.text :primary_reference
      t.text :phone_number
      t.boolean :text_message
      t.text :dock
      t.text :note
      t.text :status

      t.timestamps
    end
    add_index :dock_requests, :primary_reference
    add_index :dock_requests, :status
  end
end

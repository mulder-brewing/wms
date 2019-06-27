class CreateDocks < ActiveRecord::Migration[5.2]
  def change
    create_table :docks do |t|
      t.text :number
      t.boolean :enabled, default: true
      t.references :dock_group, foreign_key: true

      t.timestamps
    end
  end
end

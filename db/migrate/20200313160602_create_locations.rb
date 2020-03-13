class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.references :company, null: false, foreign_key: true
      t.text :ref
      t.text :name
      t.text :address_1
      t.text :address_2
      t.text :city
      t.text :state
      t.text :postal_code
      t.text :country
      t.boolean :enabled

      t.timestamps
    end
    add_index :locations, :ref
    add_index :locations, :name
    add_index :locations, :city
    add_index :locations, :state
    add_index :locations, :country
    add_index :locations, :enabled
    add_index :locations, [:company_id, :ref], unique: true
  end
end

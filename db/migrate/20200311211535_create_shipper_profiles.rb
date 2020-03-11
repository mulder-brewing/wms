class CreateShipperProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :shipper_profiles do |t|
      t.references :company, null: false, foreign_key: true
      t.references :shipper, null: false, foreign_key: { to_table: 'companies' }
      t.boolean :enabled, default: true

      t.timestamps
    end
    add_index :shipper_profiles, :enabled
    add_index :shipper_profiles, [:company_id, :shipper_id], unique: true
  end
end

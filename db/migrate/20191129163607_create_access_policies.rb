class CreateAccessPolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :access_policies do |t|
      t.references :company, null: false, foreign_key: true
      t.text :description
      t.boolean :dock_groups
      t.boolean :docks

      t.timestamps
    end
  end
end

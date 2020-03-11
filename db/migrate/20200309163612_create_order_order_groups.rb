class CreateOrderOrderGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :order_order_groups do |t|
      t.text :description, null: false
      t.boolean :enabled, default: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end

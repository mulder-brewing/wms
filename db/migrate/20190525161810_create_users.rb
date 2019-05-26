class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :username, index: {unique: true}
      t.text :first_name
      t.text :last_name
      t.text :email
      t.boolean :enabled, default: true
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end

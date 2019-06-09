class AddPasswordResetToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password_reset, :boolean, default: true
  end
end

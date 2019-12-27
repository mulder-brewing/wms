class ChangeUsersToAuthUsers < ActiveRecord::Migration[6.0]
  def change
    rename_table :users, "auth/users"
  end
end

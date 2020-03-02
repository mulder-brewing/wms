class AddAccessPolicyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :access_policy, foreign_key: true
  end
end

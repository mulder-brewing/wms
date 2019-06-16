class AddCompanyToDockRequests < ActiveRecord::Migration[5.2]
  def change
    add_reference :dock_requests, :company, foreign_key: true
  end
end

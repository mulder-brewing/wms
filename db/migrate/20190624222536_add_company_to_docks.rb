class AddCompanyToDocks < ActiveRecord::Migration[5.2]
  def change
    add_reference :docks, :company, foreign_key: true
  end
end

class AddShipperProfilesToAccessPolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :access_policies, :shipper_profiles, :boolean
  end
end

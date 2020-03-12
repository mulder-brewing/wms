require 'test_helper'

class ShipperProfileTest < ActiveSupport::TestCase

  def setup
    @shipper_profile = shipper_profiles(:shipper_profile)
  end

  test "shipper profile is valid" do
    assert @shipper_profile.valid?
  end

  test "shipper profile is invalid without a company_id" do
    @shipper_profile.company_id = nil
    assert_not @shipper_profile.valid?
  end

  test "shipper profile is invalid without a shipper_id" do
    @shipper_profile.shipper_id = nil
    assert_not @shipper_profile.valid?
  end

  test "shipper profile must be unique by shipper and company id combination" do
    @new = @shipper_profile.dup
    assert_not @new.valid?
  end
  
end

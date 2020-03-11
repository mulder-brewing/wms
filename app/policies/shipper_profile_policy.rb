class ShipperProfilePolicy < ApplicationPolicy

  def initialize(*)
    super
    @permission = :shipper_profiles
  end

  class Scope < Scope
    def resolve
      super.includes_shipper.order("companies.name asc")
    end
  end

end

class LocationPolicy < ApplicationPolicy

  def initialize(*)
    super
    @permission = :locations
  end

  class Scope < Scope
    def resolve
      super.order(:name)
    end
  end

end

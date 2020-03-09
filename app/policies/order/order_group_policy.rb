class Order::OrderGroupPolicy < ApplicationPolicy

  def initialize(*)
    super
    @permission = :order_order_groups
  end

  class Scope < Scope
    def resolve
      super.order(:description)
    end
  end

end

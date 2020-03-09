require 'test_helper'

class Order::OrderGroupTest < ActiveSupport::TestCase

  def setup
    @default = order_order_groups(:default)

    @other_company = companies(:other_company)
  end

  test "order group should be valid" do
    assert @default.valid?
  end

  test "order group without description is invalid" do
    @default.description = nil
    assert_not @default.valid?
  end

  test "order group with blank blank description is invalid" do
    @default.description = ""
    assert_not @default.valid?
  end

  test "order group description should be 50 characters or less" do
    @default.description = "a"*50
    assert @default.valid?
    @default.description = "a"*51
    assert_not @default.valid?
  end

  test "order group description should be unique irregardless of case" do
    new_company = Order::OrderGroup.new(
      description: @default.description.swapcase,
      company_id: @default.company_id
    )
    assert_not new_company.valid?
    # valid if it's same name in different company.
    new_company.company_id = @other_company.id
    assert new_company.valid?
  end

  test "whitespace should be stripped from front and end of description." do
    @default.description = "     description     "
    assert_equal "description", @default.description
    @default.description = "  \t   description   \n  "
    assert_equal "description", @default.description
  end

end

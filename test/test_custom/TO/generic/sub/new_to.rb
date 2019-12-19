class NewTO < NewEditTO

  def new_path
    new_polymorphic_path(@model)
  end

  def test(test)
    test.new_to_test(self)
  end

  def enabled_present?
    # Without setting enabled_present, assume it should not be there.
    @enabled_present.nil? ? false : @enabled_present
  end

end

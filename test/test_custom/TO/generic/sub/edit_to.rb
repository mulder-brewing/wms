class EditTO < NewEditTO
  include NotFound

  def test(test)
    test.edit_to_test(self)
  end

  def edit_path
    edit_polymorphic_path(@model)
  end

  def enabled_present?
    # Without setting enabled_present, assume it should be there.
    @enabled_present.nil? ? true : @enabled_present
  end

end

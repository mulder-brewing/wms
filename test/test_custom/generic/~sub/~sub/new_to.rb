class NewTO < NewEditTO
  include Includes::NewPath

  def initialize(user, model, validity)
    @title_text_key = "new_create"
    super(user, model, validity)
  end

  def test(test)
    test.new_to_test(self)
  end

  def enabled_present?
    # Without setting enabled_present, assume it should not be there.
    @enabled_present.nil? ? false : @enabled_present
  end

end

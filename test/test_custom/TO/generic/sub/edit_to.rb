class EditTO < NewEditTO
  include Includes::NotFound

  def initialize(user, model, validity)
    @title_text_key = "update"
    super(user, model, validity)
  end

  def test(test)
    test.edit_to_test(self)
  end

  def edit_path
    Rails.application.routes.url_helpers.edit_polymorphic_path(@model)
  end

  def enabled_present?
    # Without setting enabled_present, assume it should be there.
    @enabled_present.nil? ? true : @enabled_present
  end

end
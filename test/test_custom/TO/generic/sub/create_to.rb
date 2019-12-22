class CreateTO < CreateUpdateTO

  attr_writer :test_company_id, :test_enabled_default, :expected_company_id

  def test(test)
    test.create_to_test(self)
  end

  def create_path
    Rails.application.routes.url_helpers.polymorphic_path(@model)
  end

  def model_count
    model_class.count
  end

  def model_last
    model_class.last
  end

  def test_company_id?
    @test_company_id
  end

  def expected_company_id
    @expected_company_id ||= @user.company_id
  end

  def test_enabled_default?
    @test_enabled_default
  end

end

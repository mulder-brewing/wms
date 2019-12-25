class CreateTO < CreateUpdateTO

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

end

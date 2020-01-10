class CreateTO < CreateUpdateTO

  attr_writer :check_count

  def initialize(user, model, params_hash, validity)
    @check_count = true
    super
  end

  def test(test)
    test.create_to_test(self)
  end

  def create_path
    Rails.application.routes.url_helpers.polymorphic_path(@model)
  end

  def model_last
    model_class.last
  end

  def check_count?
    @check_count
  end

end

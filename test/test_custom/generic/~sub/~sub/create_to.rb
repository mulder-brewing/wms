class CreateTO < CreateUpdateTO

  attr_writer :check_count

  def initialize(*)
    super
    @check_count = true
    @action = :create
  end

  def test(test)
    test.create_to_test(self)
  end

  def model_last
    model_class.last
  end

  def check_count?
    @check_count
  end

end

module TranslationHelper

  def model_sing(model_class)
    model_class.model_name.human
  end

  def model_plur(model_class)
    model_class.model_name.human(count: 2)
  end

end

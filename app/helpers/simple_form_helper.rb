module SimpleFormHelper

  def sfld(key)
    return "simple_form.labels.defaults." << key
  end

  def sf_switch(**options)
    return { wrapper: :switch, as: :boolean }.merge!(options)
  end

end

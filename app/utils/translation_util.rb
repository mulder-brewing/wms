module TranslationUtil

  def self.human_attribute_enum(model, attribute)
    Hash[
      model.send(attribute.to_s.pluralize).map {
        |k,v| [k, model.human_attribute_name("#{attribute}.#{k}")]
      }
    ]
  end

end

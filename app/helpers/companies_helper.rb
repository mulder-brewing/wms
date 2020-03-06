module CompaniesHelper

  def company_types
    TranslationUtil.human_attribute_enum(Company, :company_type).invert.sort
  end

end

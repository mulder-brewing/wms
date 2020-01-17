module ValidateCompanyID

private

  def validate_company_id(to_validate, error_attribute)
    if to_validate.present? && to_validate.company_id != company_id
      errors.add(error_attribute, :does_not_belong)
    end
  end

end

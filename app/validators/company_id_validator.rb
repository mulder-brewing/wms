class CompanyIdValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.nil?
    raise ArgumentError unless value.respond_to?(:company_id)
    unless value.company_id == record.company_id
      record.errors.add(attribute, :does_not_belong)
    end
  end

end

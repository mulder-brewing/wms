class BasicRecordForm < RecordForm

  validate :record_valid

  attr_accessor :table_class, :page_class

  def setup_variables; end

  def persisted?
    @record.persisted?
  end

  def id
    @record.id
  end

  def prep_record(params)
    if params.has_key?(:id)
      @record = controller_model.find(params[:id])
    else
      @record = controller_model.new
    end
  end

  def permitted_params
    []
  end

  def validate_and_save(record)
    if valid?
      record.save!
      @submit_success = true
    else
      @submit_success = false
    end
  end

  def table
    @table_class.new(current_user)
  end

  def page
    @page_class.new(current_user, controller)
  end

  private

  def private_submit
    if @record.has_attribute?(:company_id)
      @record.company_id ||= current_company_id
    end
    validate_and_save(@record)
  end

  def record_valid
    unless @record.valid?
      errors.merge!(@record.errors)
    end
  end

  def find_to_validate(validate_class, validate_id)
    return validate_class.find_by(id: self.send(validate_id))
  end

  def validate_enabled(validate_class, validate_id)
    to_validate = find_to_validate(validate_class, validate_id)
    if to_validate.present? && to_validate.enabled == false
      errors.add(validate_id, :disabled)
    end
  end

end

class BasicRecordForm < RecordForm

  validate :record_valid

  attr_accessor :record

  def setup_variables; end
  def table; end

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

  def submit
    @record.company_id ||= current_company_id
    validate_and_save(@record)
  end

  def validate_and_save(record)
    if valid?
      record.save!
      @save_success = true
    else
      @save_success = false
    end
  end

  private

  def record_valid
    unless @record.valid?
      errors.merge!(@record.errors)
    end
  end

end

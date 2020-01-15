class BasicRecordForm < RecordForm

  validate :record_valid

  attr_accessor :record, :table_class

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

  def submit
    if @record.has_attribute?(:company_id)
      @record.company_id ||= current_company_id
    end
    validate_and_save(@record)
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
    @table_class.new(current_user) if action?(:create, :update)
  end

  private

  def record_valid
    unless @record.valid?
      errors.merge!(@record.errors)
    end
  end

end

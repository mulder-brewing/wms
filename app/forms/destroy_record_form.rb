class DestroyRecordForm < RecordForm

  attr_accessor :record, :to_delete, :post_submit

  def prep_record(params)
    @record = controller_model.find(params[:id])
  end

  def submit
    @post_submit = true
    @record.destroy
    @submit_success = true
  end

  def post_submit?
    @post_submit
  end

end

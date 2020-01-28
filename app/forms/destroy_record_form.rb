class DestroyRecordForm < RecordForm

  def prep_record(params)
    @record = controller_model.find(params[:id])
  end

  def view_path
    nil
  end

  private

  def private_submit(modal)
    if record.destroy
      @submit_success = true
    else
      modal.error = true
    end
  end

end

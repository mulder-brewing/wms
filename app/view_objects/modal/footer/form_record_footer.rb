class Modal::Footer::FormRecordFooter < Modal::Footer::FormFooter

  TIMESTAMPS_CLASS = "modal-record-timestamps"

  attr_accessor :show_timestamps

  def show_timestamps?
    @show_timestamps
  end

  def timestamps_class
    TIMESTAMPS_CLASS
  end

end

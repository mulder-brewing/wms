class RecordForm < BaseForm

  CSS_ID = "record-form"

  attr_accessor :save_success, :view_class

  delegate :record_name, to: :class

  def initialize(*)
    super
    @view_class = self.class
  end

  def css_id
    CSS_ID
  end

  def self.record_name
    self.model_name.to_s.underscore.sub("/", "_")
  end

  def view_path()
    @controller.controller_path + "/" + @view_class.name.demodulize.underscore
  end

end

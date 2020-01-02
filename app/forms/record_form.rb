class RecordForm < BaseForm
  include FindObjectHelper

  CSS_ID = "record-form"

  attr_accessor :save_success

  delegate :record_name, to: :class

  def css_id
    CSS_ID
  end

  def self.record_name
    self.model_name.to_s.underscore.sub("/", "_")
  end

  def view_path(view_class = nil)
    view_class ||= self.class
    @controller.controller_path + "/" + view_class.name.demodulize.underscore
  end

  def controller_model
    @controller.controller_path.classify.constantize
  end

end

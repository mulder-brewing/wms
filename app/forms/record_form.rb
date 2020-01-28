class RecordForm < BaseForm

  HTML_ID = "record-form"

  attr_accessor :record, :submit_success, :view_class

  delegate :record_name, :html_id, to: :class

  def initialize(*)
    super
    @view_class = self.class
  end

  def self.html_id
    HTML_ID
  end

  def self.record_name
    self.model_name.to_s.underscore.sub("/", "_")
  end

  def controller_view_path
    controller.controller_path + "/"
  end

  def view_path
    path = controller_view_path
    if action?(:show)
      path << "show"
    else
      path << @view_class.name.demodulize.underscore
    end
    return path
  end

  def error_js_path
    controller_view_path + controller.action_name + "_error"
  end

end

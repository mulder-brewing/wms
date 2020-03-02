module Button::BtnLinkOptions

  attr_accessor :remote, :path, :method, :record

  def initialize(**options)
    super(options)
    @remote = options[:remote]
    @path = options[:path]
    @method = options[:method]
    @record = options[:record]
  end

  def btn_options
    { remote: remote, path: @path, method: method, record: record,
      class: btn_class, id: btn_id }
  end

  def path(record = nil)
    raise ArgumentError if record.nil? && @path.nil?
    @path || record_path(record)
  end

  def link?
    true
  end

end

module Button::BtnLinkOptions

  attr_accessor :remote, :path, :method

  def initialize(**options)
    super(options)
    @remote = options[:remote]
    @path = options[:path]
    @method = options[:method]
  end

  def btn_link_options
    { remote: @remote, path: @path, method: @method, class: btn_class }
  end

  def path(record = nil)
    raise ArgumentError if record.nil? && @path.nil?
    @path || record_path(record)
  end

end

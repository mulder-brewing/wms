class Navbar::NavItem::BaseNavItem

  HTML_OPTIONS = {}

  attr_accessor :id, :name, :text_key, :path, :show

  def initialize(**options)
    @id = options[:id]
    @name = options[:name]
    @text_key = options[:text_key]
    @path = options[:path]
    @show = options[:show]
  end

  def name
    @name || I18n.t(text_key)
  end

  def html_options
    self.class::HTML_OPTIONS.merge!( { id: id } )
  end

  def show?
    show
  end

end

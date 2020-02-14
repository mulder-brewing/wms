class Navbar::NavItem::BaseNavItem

  HTML_OPTIONS = {}

  attr_accessor :name, :text_key, :path, :show

  delegate :id, to: :class

  def initialize(**options)
    @name = options[:name]
    @text_key = options[:text_key]
    @path = options[:path]
    @show = options[:show]
  end

  def self.id
    name.demodulize
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

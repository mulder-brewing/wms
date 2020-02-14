class Navbar::BaseNavbar

  BASE_CLASS = "navbar navbar-expand-md "

  attr_accessor :classes, :toggler_id

  delegate :id, to: :class

  def initialize(**options)
    @classes = options[:class]
    @toggler_id = options[:toggler_id]
  end

  def navbar_class
    BASE_CLASS + classes
  end

  def self.id
    name.demodulize
  end

  def toggler_target
    toggler_id.present? ? "##{toggler_id}" : ""
  end

end

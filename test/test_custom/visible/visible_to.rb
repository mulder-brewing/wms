class VisibleTO

  attr_accessor :selector, :class, :id, :visible, :text, :count, :jquery

  def initialize(**attributes)
    attributes.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def select
    array = [@selector, class_select, id_select]
    return array.select(&:present?).join(" ")
  end

  def select_options
    return @visible unless @visible.nil?
    h = {}
    h[:count] = @count if @count.present?
    h[:text] = @text if @text.present?
    return h
  end

  def class_select
    @class.nil? ? nil : ".#{@class}"
  end

  def id_select
    @id.nil? ? nil : "##{@id}"
  end
end

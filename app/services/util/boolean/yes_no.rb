class Util::Boolean::YesNo < ApplicationService

  attr_reader :boolean

  def initialize(boolean)
    @boolean = ActiveModel::Type::Boolean.new.cast(boolean)
  end

  def call
    key = @boolean ? "global.boolean.yes_no.yes" : "global.boolean.yes_no.no"
    return I18n.t(key)
  end

end

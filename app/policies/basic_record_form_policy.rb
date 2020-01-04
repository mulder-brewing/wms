class BasicRecordFormPolicy < ApplicationPolicy

  attr_reader :form

  def initialize(user, record)
    super
    @form = record
    @record = @form.record
  end

end

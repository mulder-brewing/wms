module BooleanUtil

  def self.cast(boolean)
    return ActiveModel::Type::Boolean.new.cast(boolean)
  end

  def self.yes_no(boolean)
    boolean = ActiveModel::Type::Boolean.new.cast(boolean)
    key = boolean ? "simple_form.yes" : "simple_form.no"
    return I18n.t(key)
  end

end

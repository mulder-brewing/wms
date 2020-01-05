module Util::Boolean

  class Cast < ApplicationService
    def initialize(boolean)
      @boolean = boolean
    end

    def call
      return ActiveModel::Type::Boolean.new.cast(@boolean)
    end
  end

  class YesNo < ApplicationService
    def initialize(boolean)
      @boolean = ActiveModel::Type::Boolean.new.cast(boolean)
    end

    def call
      key = @boolean ? "global.boolean.yes" : "global.boolean.no"
      return I18n.t(key)
    end
  end

end

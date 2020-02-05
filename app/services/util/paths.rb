module Util::Paths

  class New < ApplicationService
    def initialize(record)
      @record = record
    end

    def call
      Rails.application.routes.url_helpers.polymorphic_url(@record,
        routing_type: :path, action: :new)
    end
  end

  class Edit < ApplicationService
    def initialize(record)
      @record = record
    end

    def call
      Rails.application.routes.url_helpers.polymorphic_url(@record,
        routing_type: :path, action: :edit)
    end
  end

  class Show < ApplicationService
    def initialize(record)
      @record = record
    end

    def call
      Rails.application.routes.url_helpers.polymorphic_url(@record,
        routing_type: :path)
    end
  end

  class Path < ApplicationService
    def initialize(path, **args)
      @path = path
      @args = args
    end

    def call
      Rails.application.routes.url_helpers.send(@path, @args)
    end
  end



end

module Includes

  module NotFound

    def test_nf(test)
      test.not_found_to_test(self)
    end

  end

  module IndexPath

    attr_accessor :query

    def index_path
      path = Rails.application.routes.url_helpers.polymorphic_path(@model)
      case @query
      when nil
        return path
      when String
        return path + "?#{@query}"
      when :enabled
        return path + "?enabled=true"
      when :disabled
        return path + "?enabled=false"
      end
    end

  end

end

module Includes

  module NotFound

    def test_nf(test)
      test.not_found_to_test(self)
    end

  end

  module NewPath

    def new_path
      Rails.application.routes.url_helpers.new_polymorphic_path(@model)
    end

  end

  module IndexPath

    attr_accessor :query

    def index_path
      path = Rails.application.routes.url_helpers.polymorphic_path(@model)
      case @query
      when nil
        return path
      when :enabled
        return path + "?enabled=true"
      when :disabled
        return path + "?enabled=false"
      end
    end

  end

  module Title

    attr_writer :title, :test_title, :title_text_key

    def title
      return I18n.t(@title) unless @title.nil?
      I18n.t(@model.title(@title_text_key))
    end

    def test_title?
      @test_title
    end

  end

  module Inputs

    attr_accessor :inputs, :select_jquery_method

    def add_input(input)
      @inputs ||= []
      @inputs << input
    end

    def test_inputs?
      !@inputs.blank?
    end

  end
end

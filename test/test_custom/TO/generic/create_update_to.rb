class CreateUpdateTO < GenericTO
  include Includes::Inputs

  attr_accessor :params_hash, :error_to_array, :attributes

  def initialize(user, model, params_hash, validity)
    @params_hash = params_hash
    @select_jquery_method = "select_form"
    super(user, model, validity)
  end

  def params
    { @model.record_name.to_sym => @params_hash }
  end

  def merge_params_hash(to_merge)
    @params_hash = @params_hash.merge(to_merge)
  end

  def test_errors?
    !@error_to_array.blank?
  end

  def add_error_to(error_to)
    @error_to_array ||= []
    @error_to_array << error_to
  end

  def error(error_to)
    field_name = error_to.field.to_s.humanize
    case error_to.type
    when :unique
      /#{ field_name + " " + I18n.t("form.errors.taken") }/
    end
  end

  def test_attributes?
    !@attributes.blank?
  end

  def xhr_switch_params
    super({ params: params })
  end

end

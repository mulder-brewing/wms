class CreateUpdateTO < GenericTO

  attr_accessor :params_key, :params_hash, :attributes

  def initialize(user, model, params_hash, validity)
    super(user, model, validity)
    @params_hash = params_hash
    @select_jquery_method = :select_form
  end

  def params
    key = @params_key || @model.model_name.to_s.underscore.sub("/", "_").to_sym
    { key => @params_hash }
  end

  def merge_params_hash(to_merge)
    @params_hash = @params_hash.merge(to_merge)
  end

  def test_attributes?
    !@attributes.blank?
  end

  def xhr_switch_params
    super({ params: params })
  end

  def path
    @path || PathUtil.record(@model)
  end

end

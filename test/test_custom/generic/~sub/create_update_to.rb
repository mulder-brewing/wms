class CreateUpdateTO < GenericTO

  attr_accessor :params, :params_key, :params_hash, :attributes

  def initialize(*args, **options)
    super
    @params = options[:params]
    @params_key = options[:params_key]
    @params_hash = options[:params_hash]
    @select_jquery_method = :select_form
  end

  def params
    return @params unless @params.nil?
    key = @params_key || form_or_model_key
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
    @path || controller_action_path || PathUtil.record(@model)
  end

  def controller_action_path
    super(id: model.id)
  end

  private

  def form_or_model_key
    x = form_class || model
    x.model_name.param_key.to_sym
  end

end

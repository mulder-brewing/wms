class CreateUpdateTO < GenericTO

  attr_accessor :params_hash, :unique_fields_array

  def initialize(user, model, params_hash, validity)
    @params_hash = params_hash
    super(user, model, validity)
  end

  def params
    { @model.record_name.to_sym => @params_hash }
  end

  def merge_params_hash(to_merge)
    @params_hash = @params_hash.merge(to_merge)
  end

  def test_uniqueness?
    !@unique_fields_array.blank?
  end

  def add_unique_field(field)
    @unique_fields_array ||= []
    @unique_fields_array << field
  end

  def uniqueness_error(field)
    /#{model_class.human_attribute_name(field) +
      " has already been taken"}/
  end

end

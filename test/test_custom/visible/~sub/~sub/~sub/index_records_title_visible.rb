class IndexRecordsTitleVisible < HeaderTitleVisible

  def initialize(*)
    super
    @text = @model_class.model_name.human(count: 2)
  end
  
end

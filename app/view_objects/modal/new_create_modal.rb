class Modal::NewCreateModal < Modal::FormRecordModal

  def initialize(*)
    super
    @role = :new_create
    @save_result = Table::SaveResult::INSERT
    @footer = Modal::Footer::NewCreateFooter.new(@form)
    @title_suffix = "new_create"
  end

end

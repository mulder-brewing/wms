class Modal::NewCreateModal < Modal::FormRecordModal

  def initialize(*)
    super
    @role = :new_create
    @footer = Modal::Footers::NewCreateFooter.new
    @title_suffix = "new_create"
  end

end

class Modal::NewCreateModal < Modal::FormRecordModal

  def initialize(*)
    super
    @role = :new_create
    @footer = Modal::Footers::NewCreateFooter.new
  end

  def title
    super + "new_create"
  end

end

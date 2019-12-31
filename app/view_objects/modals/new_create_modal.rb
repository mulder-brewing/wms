class Modals::NewCreateModal < Modals::FormRecordModal

  def initialize(*)
    super
    @role = :new_create
    @footer = Modals::Footers::NewCreateFooter.new
  end

  def title
    super + "new_create"
  end

end

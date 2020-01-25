class DockQueue::DockAssignmentForm < BasicRecordForm

  delegate  :status, :status=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "DockQueue::DockAssignment")
  end

  def initialize(*)
    super
    @table_class = Table::DockRequestsIndexTable
    @page_class = Page::DockRequestsPage
  end

  def prep_record(params)
    @record = DockQueue::DockRequest.find(params[:id])
  end

end

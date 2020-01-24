class DockRequestForm < BasicRecordForm

  delegate  :primary_reference, :primary_reference=,
            :phone_number, :phone_number=,
            :text_message, :text_message=,
            :note, :note=,
            :dock_group_id, :dock_group_id=,
            to: :@record

  def self.model_name
    ActiveModel::Name.new(self, nil, "DockRequest")
  end

  def initialize(*)
    super
    @table_class = Table::DockRequestsIndexTable
    @page_class = Page::DockRequestsPage
  end

  def prep_record(params)
    super(params)
    unless params.has_key?(:id)
      @record.dock_group_id = params[:dock_group_id]
    end
  end

  def permitted_params
    [:primary_reference, :phone_number, :text_message, :note, :dock_group_id]
  end

end

class Table::DockQueue::DockRequestsIndexTable < Table::IndexTable

  attr_accessor :card_column_btns, :card_row_btns

  def initialize(*)
    super
    @insert_method = Table::Insert::APPEND

    @card_column_btns = []
    card_column_btn_options = {
      remote: true,
      size: Button::Size::SMALL,
      block: true
    }
    @card_column_btns << Button::EditButton.new(card_column_btn_options)
    @card_column_btns << Button::ShowButton.new(card_column_btn_options)

    @card_row_btns = []
    @card_row_btns << Button::DockQueue::CardVoidButton.new
    @card_row_btns << Button::DockQueue::AssignDockButton.new
    @card_row_btns << Button::DockQueue::UnassignDockButton.new
    @card_row_btns << Button::DockQueue::CheckOutButton.new

  end

  def prep_records(dock_group)
    unless dock_group.nil?
      @records = DockQueue::DockRequest.where_company_and_group(current_company_id, dock_group.id).include_docks.active
    else
      @records = DockQueue::DockRequest.none
    end
  end

  def record_html_path
    "dock_queue/dock_requests/dock_request"
  end

end

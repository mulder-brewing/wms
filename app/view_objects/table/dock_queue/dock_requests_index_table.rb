class Table::DockQueue::DockRequestsIndexTable < Table::IndexTable

  attr_accessor :card_buttons

  def initialize(*)
    super
    @insert_method = Table::Insert::APPEND

    card_column_btn_options = {
      remote: true,
      size: Button::Size::SMALL,
      block: true
    }
    @card_buttons = {
      :column_btns => [
        Button::EditButton.new(card_column_btn_options),
        Button::ShowButton.new(card_column_btn_options),
      ],
      "checked_in" => [
        Button::DockQueue::CardVoidButton.new,
        Button::DockQueue::AssignDockButton.new,
      ],
      "dock_assigned" => [
        Button::DockQueue::UnassignDockButton.new,
        Button::DockQueue::CheckOutButton.new
      ]
    }
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

  def buttons_for_status(status)
    card_buttons[status] || []
  end

end

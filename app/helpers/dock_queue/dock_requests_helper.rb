module DockQueue::DockRequestsHelper

  def dock_number(record)
    t("dock_queue/dock_requests.dock_number", number: record.dock.number)
  end

  def checked_in_time(record)
    tag.p local_time_ago(record.created_at)
  end

  def card_column_btns(table, record)
    html = ""
    table.card_column_btns.each do |btn|
      html << content_tag(:div, btn(btn, record: record), class: "col")
    end
    return html.html_safe
  end

  def status_change_btns(table, record)
    buttons = table.card_row_btns.select { |b| b.show_status == record.status }
    html = ""
    buttons.each do |btn|
      html << content_tag(:div, btn(btn, record: record), class: "row mb-2")
    end
    return html.html_safe
  end

end

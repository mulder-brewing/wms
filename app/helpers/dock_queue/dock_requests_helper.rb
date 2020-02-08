module DockQueue::DockRequestsHelper

  def dock_number(record)
    t("dock_queue/dock_requests.dock_number", number: record.dock.number)
  end

  def checked_in_time(record)
    tag.p local_time_ago(record.created_at)
  end

  def card_title(record)
    if record.status_checked_in?
      t = record.human_attribute_name("status.checked_in")
    else
      t = dock_number(record)
    end
    content_tag(:h4, t, class: "card-title")
  end

  def card_buttons(table, record)
    html = "".html_safe
    table.card_buttons[:column_btns].each do |b|
      html << content_tag(:div, btn(b, record: record), class: "col")
    end
    html = button_row(html)
    table.buttons_for_status(record.status).each do |b|
      html << button_row(btn(b, record: record))
    end
    return html
  end

  def button_row(html)
    content_tag(:div, html, class: "row mb-2")
  end

end

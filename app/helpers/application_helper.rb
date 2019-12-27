module ApplicationHelper

  #Pagination
  include Pagy::Frontend

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Mulder WMS"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def errors_for(object)
      if object.errors.any?
          content_tag(:div, class: "card border-danger mb-3") do
              concat(content_tag(:div, class: "card-header bg-danger text-white") do
                  concat "#{pluralize(object.errors.count, "error")} prohibited this from being saved:"
              end)
              concat(content_tag(:ul, class: 'mb-0 list-group list-group-flush') do
                  object.errors.full_messages.each do |msg|
                      concat content_tag(:li, msg, class: 'list-group-item')
                  end
              end)
          end
      end
  end

  def header_icon(icon_class = '')
    if icon_class.empty?
      return
    else
      content_tag(:i, class: icon_class) do
      end
    end
  end

  # Returns Yes for true and No for false.
  def human_boolean(boolean)
    boolean ? "global.boolean.yes_no.yes" : "global.boolean.yes_no.no"
  end

  # Returns local time if not blank
  def local_time_if_not_blank(date_time)
    if !date_time.blank?
      local_time(date_time)
    end
  end

  def t_nf(key)
    I18n.t key, default: key
  end


end

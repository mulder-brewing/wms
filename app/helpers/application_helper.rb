module ApplicationHelper
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
                  concat "#{pluralize(object.errors.count, "error")} prohibited this #{object.class.name.downcase} from being saved:"
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


end

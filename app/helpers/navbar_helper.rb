module NavbarHelper

  def build_navigation(navbar)
    html = "".html_safe
    navbar.roots.each { |root| html << navbar_dropdown(root) }
    return html
  end

  def navbar_dropdown(dropdown)
    html = "".html_safe
    return html unless dropdown.show?
    html << (
      content_tag :li, class: "nav-item dropdown" do
        nav_item_link(dropdown) + dropdown_items(dropdown)
      end
    )
    return html
  end

  def dropdown_items(dropdown)
    html = build_dropdown(dropdown)
    return html unless html.present?
    return content_tag(
      :ul,
      html,
      class: "dropdown-menu",
      :'aria-labelledby' => dropdown.id
    )
  end

  def build_dropdown(dropdown)
    html = "".html_safe
    items = dropdown.items
    return html unless items.present?
    items.each { |item| html << link_or_sub_dropdown(item) }
    return html
  end

  def link_or_sub_dropdown(item)
    return "" unless item.show?
    html = tag.li(item.respond_to?(:items) ? sub_dropdown(item) : nav_item_link(item))
    return html
  end

  def nav_item_link(item)
    link_to item.name, item.path, item.html_options
  end

  def sub_dropdown(dropdown)
    html = build_dropdown(dropdown)
    return html unless html.present?
    html = tag.ul(html, class: "dropdown-menu")
    return html.prepend(nav_item_link(dropdown))
  end

  def navbar_toggler(navbar)
    button_tag(class: "navbar-toggler", type: "button", data: { toggle: "collapse", target: navbar.toggler_target }, aria: { controls: "navbarToggler",  expanded: "false", label: "Toggle navigation" } ) do
      tag.span(class: "navbar-toggler-icon")
    end


  end

end

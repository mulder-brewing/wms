module NavbarHelper

  def setup_navbar
    return Navbar::MainNavbar.new
  end

  def navbar_dropdown(dropdown)
    html = "".html_safe
    return html unless dropdown.show?
    html << (
      content_tag :div, class: "nav-item dropdown" do
        nav_item_link(dropdown) + dropdown_items(dropdown)
      end
    )
    return html
  end

  def dropdown_items(dropdown)
    items = dropdown.items
    html = "".html_safe
    return html if items.empty?
    items.each do |item|
      html << nav_item_link(item) if item.show?
    end
    return content_tag(
      :div,
      html,
      class: "dropdown-menu",
      :'aria-labelledby' => dropdown.id
    )
  end

  def nav_item_link(nav_item)
    link_to nav_item.name, nav_item.path, nav_item.html_options
  end



end

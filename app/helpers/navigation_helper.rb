module NavigationHelper
  
  def navigation_menu
    items = []
    navigation_items.each do |item|
      items << content_tag(:li, link_to(item[:text], item[:link]))
    end
    content_tag(:ul, items)
  end
  
  private
  def navigation_items
    [
      {:text => 'Home', :link => root_path},
      {:text => 'Brands', :link => brands_path},
      {:text => 'Members', :link => users_path}
    ]
  end
end

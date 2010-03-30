module NavigationHelper
  
  def navigation_menu
    items = []
    navigation_items.each do |item|
      items << content_tag(:li, link_to(item[:text], item[:link]))
    end
    content_tag(:ul, items, :id => 'main_navigation')
  end
  
  private
  def navigation_items
    [
      {:text => 'Brands', :link => brands_path},
      {:text => 'Shops', :link => '#'},
      {:text => 'Users', :link => users_path}
    ]
  end
end

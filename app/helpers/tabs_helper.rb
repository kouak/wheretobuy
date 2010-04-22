module TabsHelper
  def selected_tab
    @selected_tab
  end
  
  def selected_tab=(a)
    @selected_tab = a
  end
  
  def tabs(selected = nil, links = [])
    
    selected ||= @selected_tab
    
    links.map! do |l|
      if l[:title].downcase == selected.to_s.downcase
        l.merge({:class => 'selected'})
      else
        l.merge({:class => nil})
      end
    end
    
    rtn = links.inject('') do |s, l|
      i = l[:class]
      s + content_tag('li', link_to(l[:title], l[:url]), :class => l[:class])
    end
    
    rtn = content_tag('ul', rtn)
    
    rtn
  end
  
  def brand_tabs(selected = @selected_tab, brand = @brand)
    links = [
      {:title => 'Brand', :url => brand_path(brand)},
      {:title => 'Activity', :url => brand_activity_path(brand)},
      {:title => 'Wiki', :url => brand_brand_wiki_path(brand)},
      {:title => 'Tags', :url => brand_tags_path(brand)},
      {:title => 'Similar brands', :url => '#'},
      {:title => 'Images', :url => '#'},
      {:title => 'Fans', :url => brand_fans_path(brand)},
      {:title => 'Comments', :url => brand_comments_path(brand)}
    ]
    tabs(selected, links)
  end
  
  def account_tabs(selected = 'Settings', user = current_user)
    links = [
      {:title => 'Settings', :url => edit_account_path},
      {:title => 'My pictures', :url => '#'},
      {:title => 'My friends', :url => '#'},
      {:title => 'See my profile', :url => user_path(user)},
    ]
    tabs(selected, links)
  end
  
  def user_tabs(selected = 'User', user = @user)
    links = [
      {:title => 'User', :url => user_path(user)},
      {:title => 'Activity', :url => '#'},
      {:title => 'Friends', :url => user_friends_path(user)},
      {:title => 'Favorite brands', :url => user_favorite_brands_path(user)},
      {:title => 'Comments', :url => user_comments_path(user)}
    ]
    
    tabs(selected, links)
  end
end
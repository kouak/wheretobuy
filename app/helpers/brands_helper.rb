module BrandsHelper
  
  def selected_tab
    @selected_tab
  end
  
  def selected_tab=(a)
    @selected_tab = a
  end
  
  def brand_tabs(selected = nil, brand = @brand)

    links = [
      {:title => 'Brand', :url => brand_path(@brand)},
      {:title => 'Activity', :url => '#'},
      {:title => 'Wiki', :url => brand_brand_wiki_path(@brand)},
      {:title => 'Tags', :url => '#'},
      {:title => 'Similar brands', :url => '#'},
      {:title => 'Images', :url => '#'},
      {:title => 'Fans', :url => brand_fans_path(@brand)},
      {:title => 'Comments', :url => brand_comments_path(@brand)}
    ]
    
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
  
  def brand_avatar(brand = @brand, *args)
    image_tag('blank-profile-150x150.png', :height => 50)
  end
  
  def brand_title(subtitle = nil, *args)
    
    configuration = {
      :title_tag => :h1,
      :html_options => {:id => 'brand-title'},
      :brand => @brand
    }
    
    configuration.update(args.extract_options!)
    brand = configuration[:brand]
    case brand
    when Brand
      title = link_to(brand)
    else
      title = brand.to_s or raise ArgumentError
    end
    
    title = content_tag(configuration[:title_tag], title)
    subtitle = content_tag(:span, subtitle.to_s, :class => 'subtitle')
    picture = content_tag(:div, brand_avatar(brand), :class => 'picture-wrapper')
    
    stylesheet('brands/title')
    
    content_tag(:div, picture + title + subtitle, configuration[:html_options])
    
  end
end

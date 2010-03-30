module BrandsHelper
  
  def brand_avatar(brand = @brand, *args)
    image_tag('blank-profile-150x150.png', :height => 50)
  end
  
  def brand_profile_link(brand, *args)
    if brand.is_a?(Brand)
      link_to h(brand.to_s), brand
    else
      'deleted brand'
    end
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

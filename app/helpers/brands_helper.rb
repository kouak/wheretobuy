module BrandsHelper
  def brand_tabs(selected, brand = @brand)
    
    stylesheet('brands/show')

    links = [
      {:title => 'Brand', :url => brand_path(@brand)},
      {:title => 'Activity', :url => '#'},
      {:title => 'Wiki', :url => brand_brand_wiki_path(@brand)},
      {:title => 'Tags', :url => '#'},
      {:title => 'Similar brands', :url => '#'}
    ]
    
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
    
    content_tag('div', rtn, :id => 'brand-tabs')
  end
end

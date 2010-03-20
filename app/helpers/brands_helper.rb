module BrandsHelper
  def brand_tabs(selected, brand = @brand)

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
end

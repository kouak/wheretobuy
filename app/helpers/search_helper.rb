module SearchHelper
  def search_box
    top_search_box
  end
  
  def top_search_box
    form_tag search_path, :method => :get do
      concat(text_field_tag(:query))
      concat(submit_tag('search'))
    end
  end
end
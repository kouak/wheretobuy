module BrandActivityHelper
  
  def brand_activity_verb(activity)
    case activity.data[:type]
    when 'created brand'
      verb = "created #{link_to(activity.target)} profile"
    when 'added comment'
      verb = "posted #{link_to('a comment', comment_path(activity.data[:comment_id]))} on #{link_to(h(activity.target.to_s), brand_path(activity.target))}"
    when 'edited brand wiki'
      verb = "edited #{link_to(activity.target.to_s + ' wiki', brand_brand_wiki_path(activity.target, :version => activity.data[:version]))}"
    when 'voted'
      if activity.data[:score] > 0
        verb = "voted for #{link_to(h(activity.target.to_s), brand_path(activity.target))}"
      elsif activity.data[:score] < 0
        verb = "voted against #{link_to(h(activity.target.to_s), brand_path(activity.target))}"
      else
        verb = "voted on #{link_to(h(activity.target.to_s), brand_path(activity.target))}"
      end
    when 'tagged'
      taglist = activity.data[:taglist].map { |tag| brand_tag_link(tag) }
      verb = "tagged #{link_to(h(activity.target.to_s), brand_path(activity.target))} with #{taglist.to_sentence}"
    else
      verb = 'did something' # Wtf ?
    end
    
    verb += '.'
  end
  
end
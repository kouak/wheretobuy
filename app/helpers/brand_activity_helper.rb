module BrandActivityHelper
  
  def brand_activity(activity, *args)
    
    configuration = {
      :last => false
    }
    configuration.update(args.extract_options!)
    
    case activity.data[:type]
    when 'created brand'
      verb = "created #{link_to(activity.target)} profile"
    when 'added comment'
      verb = "posted #{link_to('a comment', comment_path(activity.data[:comment_id]))} on #{link_to(activity.target)}"
    when 'edited brand wiki'
      verb = "edited #{link_to(activity.target.to_s + ' wiki', brand_brand_wiki_path(activity.target, :version => activity.data[:version]))}"
    when 'voted'
      if activity.data[:score] > 0
        verb = "voted for #{link_to(activity.target)}"
      elsif activity.data[:score] < 0
        verb = "voted against #{link_to(activity.target)}"
      else
        verb = "voted on #{link_to(activity.target)}"
      end
    when 'tagged'
      taglist = activity.data[:taglist].map { |tag| brand_tag_link(tag) }
      verb = "tagged #{link_to(activity.target)} with #{taglist.to_sentence}"
    else
      verb = 'did something' # Wtf ?
    end
    
    verb += '.'
    
    subject = user_profile_link(activity.author)
    time_ago = content_tag :span, time_ago_in_words(activity.created_at) + ' ago.', :class => "time-ago"
    
    css = activity.data[:type].parameterize('_')
    css += ' last' if configuration[:last] == true
    
    return content_tag :li, [subject, verb, time_ago].join(' '), :class => css
  end
  
end
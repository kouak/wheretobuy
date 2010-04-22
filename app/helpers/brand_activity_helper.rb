module BrandActivityHelper
  
  def brand_activity(activity, *args)
    
    configuration = {
      :last => false
    }
    configuration.update(args.extract_options!)
    
    case activity.data[:type]
    when 'created brand'
      verb = 'created the profile'
    when 'added comment'
      verb = 'posted ' + link_to('a comment', comment_path(activity.data[:comment_id]))
    when 'edited brand wiki'
      verb = 'edited ' + link_to('the wiki', brand_brand_wiki_path(activity.target, :version => activity.data[:version]))
    when 'voted'
      if activity.data[:score] > 0
        verb = 'voted up'
      elsif activity.data[:score] < 0
        verb = 'voted down'
      else
        verb = 'voted'
      end
    when 'tagged'
      taglist = activity.data[:taglist].map { |tag| brand_tag_link(tag) }
      verb = 'tagged with ' + taglist.to_sentence
    else
      verb = 'did something' # Wtf ?
    end
    
    verb += '.'
    
    subject = user_profile_link(activity.author)
    time_ago = content_tag :span, time_ago_in_words(activity.created_at) + ' ago.', :class => "time-ago"
    
    css = activity.data[:type]
    css += ' last' if configuration[:last] == true
    
    return content_tag :li, [subject, verb, time_ago].join(' '), :class => css
  end
  
end
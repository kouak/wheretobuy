module ActivitiesHelper
  def big_activity(activity, *args)
    %{
      <div class="activity">
        <span class="author_picture">#{user_avatar_for_comments(activity.author, :with_link => true)}</span>
        <div class="column">
          <span class="author_name">#{user_profile_link(activity.author)}</span>
          <span class="what">#{activity_verb(activity)}</span>
          <span class="when">#{time_ago_in_words(activity.created_at)} ago</span>
        </div>
      </div>
    }
  end
  
  def activity_verb(activity)
    case activity.target
    when Brand
      verb = brand_activity_verb(activity)
    when User
      verb = user_activity_verb(activity)
    else
      verb = 'did something.'
    end
  end
  
  def li_activity(activity, *args)
    configuration = {
      :last => false
    }
    configuration.update(args.extract_options!)
    
    verb = activity_verb(activity)
    
    subject = user_profile_link(activity.author)
    time_ago = content_tag :span, time_ago_in_words(activity.created_at) + ' ago.', :class => "time-ago"
    
    css = activity.data[:type].parameterize('_')
    css += ' last' if configuration[:last] == true
    
    return content_tag :li, [subject, verb, time_ago].join(' '), :class => css
  end
end
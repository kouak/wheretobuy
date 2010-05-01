module UserActivityHelper
  
  def user_activity_verb(activity)
    case activity.data[:type]
    when 'added comment'
      verb = "added #{link_to('a comment', comment_path(activity.data[:comment_id]))} on #{link_to(activity.target.to_s + "'s profile", user_path(activity.target))}"
    else
      verb = 'did something' # Wtf ?
    end
    
    verb += '.'
  end
  
end
module UsersHelper
  
  def user_profile_link(user, *args)
    if user.is_a?(User)
      link_to h(user.to_s), user
    else
      'deleted member'
    end
  end
  
  def user_avatar(user, *args)
    configuration = {
      :width => 50,
      :height => 50
    }
    configuration.update(args.extract_options!)
    
    if(user.is_a?(User))
      image_tag('blank-profile-150x150.png', configuration)
    else
      image_tag('blank-profile-150x150.png', configuration)
    end
  end
  
  def user_title(subtitle = nil, *args)
    
    configuration = {
      :title_tag => :h1,
      :html_options => {:id => 'user-title'},
      :user => @user
    }
    
    configuration.update(args.extract_options!)
    user = configuration[:user]
    case user
    when User
      title = link_to(user)
    else
      title = user.to_s or raise ArgumentError
    end
    
    title = content_tag(configuration[:title_tag], title)
    subtitle = content_tag(:span, subtitle.to_s, :class => 'subtitle')
    picture = content_tag(:div, user_avatar(user), :class => 'picture-wrapper')
    
    stylesheet('users/title')
    
    content_tag(:div, picture + title + subtitle, configuration[:html_options])
    
  end
  
  def user_sex_to_s(user = @user)
    raise ArgumentError unless user.is_a?(User)
    case user.sex
    when User::MALE
      'Male'
    when User::FEMALE
      'Female'
    end
  end
  
  def user_location_to_s(user = @user)
    raise ArgumentError unless user.is_a?(User)
    return h("#{user.city_name} (#{user.country_name})") unless user.city.nil?
    'unknown'
  end
  
  def user_short_infos(user = @user)
    h(['22 years old', user_sex_to_s(user).downcase, user.city_name, nil, user.country_name].compact.join(', '))
  end
end
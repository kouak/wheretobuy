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
      title = link_to(h(user.to_s), user_path(user))
    else
      title = h(user.to_s) or raise ArgumentError
    end
    
    title = content_tag(configuration[:title_tag], title)
    subtitle = content_tag(:span, subtitle.to_s, :class => 'subtitle')
    picture = content_tag(:div, user_avatar(user), :class => 'picture-wrapper')
    
    stylesheet('users/title')
    
    content_tag(:div, picture + title + subtitle, configuration[:html_options])
    
  end
  
  def user_sex_to_s(user = @user)
    case user.try(:sex)
    when User::MALE
      'Male'
    when User::FEMALE
      'Female'
    else
      nil
    end
  end
  
  def user_location_to_s(user = @user)
    return h("#{user.city_name} (#{user.country_name})") unless user.try(:city).nil?
    return h("#{user.country_name}") unless user.try(:country).nil?
    nil
  end
  
  def user_age_to_s(user)
    return h("#{user.age.to_s} years old") unless user.try(:age).nil?
    nil
  end
  
  def user_short_infos(user = @user)
    [user_age_to_s(user), user_sex_to_s(user).downcase, user_location_to_s(user)].compact.join(', ')
  end
end
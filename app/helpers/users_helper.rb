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
end
module CommentsHelper
  def user_avatar_for_comments(user, *args)
    if(user.is_a?(User))
      link_to(user_avatar(user, :width => "65px", :height => nil), user)
    else
      user_avatar(user, :width => "65px", :height => nil)
    end
  end
end

module CommentsHelper
  def user_avatar_for_comments(user)
    user_avatar(user, :width => "65px", :height => nil)
  end
end

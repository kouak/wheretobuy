module VotesHelper
  
  def vote_up_link(votable, user = current_user)
    raise ArgumentError if votable.nil?
    
    if(current_user && current_user.voted_for?(votable))
      image_tag('vote/vote-arrow-up-on.png')
    else
      image_tag('vote/vote-arrow-up.png')
    end
    
  end
  
  def vote_down_link(votable, user = current_user)
    raise ArgumentError if votable.nil?
  
  end
  
  def vote_up_image(votable, user = current_user)
    raise ArgumentError if votable.nil?
    
    if(current_user && current_user.voted_for?(votable))
      image_tag('vote/vote-arrow-up-on.png')
    else
      image_tag('vote/vote-arrow-up.png')
    end
  end
  
  def vote_down_image(votable, user = current_user)
    raise ArgumentError if votable.nil?
    
    if(current_user && current_user.voted_against?(votable))
      image_tag('vote/vote-arrow-down-on.png')
    else
      image_tag('vote/vote-arrow-down.png')
    end
  end
end

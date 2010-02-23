module Votes::ActsAsVoter
  def vote_for(votable) # +1 vote
    vote_for_with_score(votable, 1)
  end
  
  def vote_against(votable) # -1 vote
    vote_for_with_score(votable, -1)
  end
  
  def vote_nil(votable) # remove vote
    Vote.find(:first, :conditions => [
      "voter_id = ? AND votable_id = ? AND votable_type = ?",
      self.id, votable.id, votable.class.name]
    ).try(:destroy)
  end
  
  def voted_for?(votable)
    0 < Vote.count(:all, :conditions =>
      [
        "voter_id = ? AND score > 0 AND votable_id = ? AND votable_type = ?",
        self.id, votable.id, votable.class.name
      ]
    )
  end

  def voted_against?(votable)
    0 < Vote.count(:all, :conditions =>
      [
        "voter_id = ? AND score < 0 AND votable_id = ? AND votable_type = ?",
        self.id, votable.id, votable.class.name
      ]
    )
  end
  
  def voted_on?(votable)
    0 < Vote.count(:all, :conditions =>
      [
        "voter_id = ? AND votable_id = ? AND votable_type = ?",
        self.id, votable.id, votable.class.name
      ]
    )
  end
  
  private
  def vote_for_with_score(votable, score)
    raise ArgumentError, "votable not defined" unless votable.respond_to?(:votes)
    raise ArgumentError, "score = 0" if score.to_i == 0
    
    @vote = votable.votes.find(:first, :conditions => {:voter_id => self.id})
    if @vote.nil?
      @vote = Vote.create(:score => score, :voter => self, :votable => votable)
    else
      @vote.score = score
      @vote.save
    end
  end
end
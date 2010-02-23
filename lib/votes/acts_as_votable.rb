module Votes::ActsAsVotable
  # All time popularity
  def popularity
    self.comments_count + self.score*10 + self.pageviews
  end
  
  # Last X days popularity
  def hype
    self.comments.recent(1.week.ago).count
  end
  
  
  # Pageviews should be used for popularity
  def pageviews
    0
  end
  
  # Vote score
  def score
    self.votes.inject(0) do |sum, vote|
      sum + vote.score.to_i
    end
  end
end
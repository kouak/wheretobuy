class Brand < ActiveRecord::Base
  attr_accessible :comments_count
  attr_accessible :name, :url
  
  validates_presence_of :name
  validates_length_of :name, :in => 2..70
  
  validates_format_of :url, :with => /^(http):\/\/.*/, :allow_nil => true, :allow_blank => true
  
  has_many :comments, :as => :resource
  has_many :votes, :as => :votable
  
  named_scope :featured,
    :limit => 5,
    :select => "*, comments_count as activity",
    :order => "activity DESC"
    
  
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
  
  def to_s
    name
  end
end

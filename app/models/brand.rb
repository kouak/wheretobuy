class Brand < ActiveRecord::Base
  attr_accessible :comments_count
  attr_accessible :name, :url
  
  validates_presence_of :name
  validates_length_of :name, :in => 2..70
  
  validates_format_of :url, :with => /^(http):\/\/.*/, :allow_nil => true, :allow_blank => true
  
  has_many :comments, :as => :resource
  has_many :votes, :as => :votable
  
  include Votes::ActsAsVotable # lib/votes/acts_as_votable.rb
  
  named_scope :featured,
    :limit => 5,
    :select => "*, comments_count as activity",
    :order => "activity DESC"
  
  def to_s
    name
  end
end

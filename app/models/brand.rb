class Brand < ActiveRecord::Base
  attr_accessible :comments_count, :brand_type_ids
  attr_accessible :name
  
  validates_presence_of :name
  validates_length_of :name, :in => 2..70
  validates_uniqueness_of :name
  
  has_many :comments, :as => :resource
  has_many :votes, :as => :votable
  has_one :brand_wiki, :dependent => :destroy # User editable content
  
  has_and_belongs_to_many :brand_types
  
  include Votes::ActsAsVotable # lib/votes/acts_as_votable.rb
  
  named_scope :featured,
    :limit => 5,
    :select => "*, comments_count as activity",
    :order => "activity DESC"
  
  def to_s
    name
  end
end

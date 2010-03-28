require 'lib/votes/acts_as_votable'
class Brand < ActiveRecord::Base
  attr_accessible :comments_count, :brand_type_ids
  attr_accessible :name
  
  validates_length_of :name, :in => 2..70
  validates_uniqueness_of :name
  
  has_many :comments, :as => :resource
  has_one :brand_wiki, :dependent => :destroy # User editable content
  
  acts_as_votable
  
  named_scope :featured,
    :limit => 5,
    :select => "*, comments_count as activity",
    :order => "activity DESC"
    
  named_scope :search, lambda { |*args| {:conditions => ['name LIKE ?', '%' + args.first + '%']}}
    
  def to_param
    id.to_s+'-'+ActiveSupport::Inflector.parameterize(to_s)
  end
  
  def to_s
    name
  end
  
end

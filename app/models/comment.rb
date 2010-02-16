class Comment < ActiveRecord::Base
  attr_accessible :author_id, :author, :status, :body, :resource_id, :resource_type
  belongs_to :resource, :polymorphic => true, :counter_cache => true
  belongs_to :author, :class_name => "User"
  
  validates_length_of :body, :minimum => 2
  validates_presence_of :author
  
  default_scope :order => 'created_at DESC' # new comments first
  
end

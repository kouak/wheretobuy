class Comment < ActiveRecord::Base
  attr_accessible :author_id, :author, :status, :body, :resource_id, :resource_type, :resource
  belongs_to :resource, :polymorphic => true, :counter_cache => true
  belongs_to :author, :class_name => "User"
  
  validates_length_of :body, :minimum => 2
  validates_presence_of :author
  validates_presence_of :resource_type
  validates_presence_of :resource_id
  
  default_scope :order => 'created_at DESC' # new comments first  
  named_scope :recent,       lambda { |*args| {:conditions => ["created_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  
end

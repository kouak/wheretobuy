class Activity < ActiveRecord::Base
  
  belongs_to :author, :class_name => 'User'
  belongs_to :target, :polymorphic => true
  
  serialize :data
  
  named_scope :recent, :order => 'created_at DESC'
  
  validates_presence_of :author_id, :target_id, :target_type
  validates_numericality_of :author_id, :target_id
  
  
  def self.added_comment(comment)
    raise ArgumentError, "must be provided with comment" if comment.nil? || !comment.is_a?(Comment)
    raise ArgumentError, "comment provided must be saved" if comment.new_record?
    new(:author => comment.author, :target => comment.resource, :data => {:type => 'added comment', :comment_id => comment.id})
  end
  
end

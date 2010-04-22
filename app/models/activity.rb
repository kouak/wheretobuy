class Activity < ActiveRecord::Base
  
  belongs_to :author, :class_name => 'User'
  belongs_to :target, :polymorphic => true
  
  serialize :data
  
  named_scope :recent, :order => 'created_at DESC'
  
  validates_presence_of :author_id, :target_id, :target_type
  validates_numericality_of :author_id, :target_id
  
  
  def self.added_comment(comment, author = nil)
    check_record(comment, Comment)
    new(:author => author || comment.author, :target => comment.resource, :data => {:type => 'added comment', :comment_id => comment.id})
  end
  
  def self.added_brand(brand, author = nil)
    check_record(brand, Brand)
    new(:author => author || brand.creator, :target => brand, :data => {:type => 'created brand'})
  end
  
  # Needs hooking + testing
  def self.edited_brand_wiki(brand_wiki, author = nil)
    check_record(brand_wiki, BrandWiki)
    new(:author => author || brand_wiki.editor, :target => brand_wiki.brand, :data => {:type => 'edited brand wiki', :version => brand_wiki.version})
  end
  
  # Needs hooking + testing
  def self.voted(vote, author = nil)
    check_record(vote, Vote)
    new(:author => author || vote.voter, :target => vote.votable, :data => {:type => 'voted', :score => vote.score })
  end
  
  def self.tagged(target, taglist, author)
    new(:author => author, :target => target, :data => {:type => 'tagged', :taglist => taglist})
  end
  
  private
  def self.check_record(record, klass)
    raise ArgumentError, "must be provided with #{klass.to_s}" if record.nil? || !record.is_a?(klass)
    raise ArgumentError, "#{klass.to_s} provided must be saved" if record.new_record?
    true
  end
end

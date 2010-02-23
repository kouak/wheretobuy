class Vote < ActiveRecord::Base
  attr_accessible :voter_sex, :score, :voter, :votable
  
  belongs_to :votable, :polymorphic => true
  belongs_to :voter, :class_name => "User"
  
  validates_presence_of :voter_id, :votable_id, :votable_type
  validates_uniqueness_of :votable_id, :scope => [:votable_type, :voter_id]
  
  named_scope :for_voter,    lambda { |*args| {:conditions => ["voter_id = ?", args.first.id, args.first.type.name]} }
  named_scope :for_votable, lambda { |*args| {:conditions => ["votable_id = ? AND votable_type = ?", args.first.id, args.first.type.name]} }
  named_scope :recent,       lambda { |*args| {:conditions => ["updated_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  named_scope :descending, :order => "updated_at DESC"
  
end

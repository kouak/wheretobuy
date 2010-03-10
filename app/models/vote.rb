class Vote < ActiveRecord::Base
  attr_accessible :voter_sex, :score, :voter, :votable

  
  belongs_to :votable, :polymorphic => true
  belongs_to :voter, :class_name => "User"
  
  validates_presence_of :voter_id, :votable_id, :votable_type
  validates_uniqueness_of :votable_id, :scope => [:votable_type, :voter_id]
  
  named_scope :for_voter,    lambda { |*args| {:conditions => ["voter_id = ?", args.first.id]} }
  named_scope :for_votable, lambda { |*args| {:conditions => ["votable_id = ? AND votable_type = ?", args.first.id, args.first.class.name]} }
  named_scope :recent,       lambda { |*args| {:conditions => ["updated_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  named_scope :descending, :order => "updated_at DESC"
  
  # Add a vote or update current
  def self.add_vote(voter, votable, score)
    if score.to_i == 0
      return self.del_vote(voter, votable)
    end
    self.check_voter_and_votable(voter, votable)
    v = self.find_by_voter_and_votable(voter, votable) || self.new(:voter => voter, :votable => votable)
    v.update_attribute(:score, score.to_i)
    v.save!
    return v
  end
  
  # Remove a vote, equivalent to Vote.add_vote(voter, votable, 0)
  def self.del_vote(voter, votable)
    self.find_by_voter_and_votable(voter, votable).try(:destroy)
  end
  
  private
  
  def self.find_by_voter_and_votable(voter, votable)
    self.check_voter_and_votable(voter, votable)
    self.for_voter(voter).for_votable(votable).first
  end
  
  def self.check_voter_and_votable(voter, votable)
    raise ArgumentError, "voter not defined" unless (voter.respond_to?(:is_voter?) && voter.id > 0)
    raise ArgumentError, "votable not defined" unless (votable.respond_to?(:is_votable?) && votable.id > 0)
    true
  end
end
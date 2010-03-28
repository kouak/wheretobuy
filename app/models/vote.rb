class Vote < ActiveRecord::Base
  attr_accessible :voter_sex, :score, :voter, :votable
  
  after_save :increment_or_decrement_fan_count
  
  belongs_to :votable, :polymorphic => true, :counter_cache => true
  belongs_to :voter, :class_name => "User"
  
  validates_presence_of :voter_id, :votable_id, :votable_type
  validates_uniqueness_of :votable_id, :scope => [:votable_type, :voter_id]
  
  named_scope :for_voter,    lambda { |*args| {:conditions => ["voter_id = ?", args.first.id]} }
  named_scope :for_votable, lambda { |*args| {:conditions => ["votable_id = ? AND votable_type = ?", args.first.id, args.first.class.name]} }
  named_scope :recent,       lambda { |*args| {:conditions => ["updated_at > ?", (args.first || 2.weeks.ago).to_s(:db)]} }
  named_scope :descending, :order => "updated_at DESC"
  
  # Add a vote or update current
  def self.add_vote(*args)
    configuration = {
      :score => 0,
      :voter => nil,
      :votable => nil
    }
    configuration.update(args.extract_options!)
    
    configuration[:score] = configuration[:score].to_i
    
    if configuration[:score] == 0
      return self.del_vote(configuration[:voter], configuration[:votable])
    end
    self.check_voter_and_votable(configuration[:voter], configuration[:votable])
    v = self.find_by_voter_and_votable(configuration[:voter], configuration[:votable]) || self.new(:voter => configuration[:voter], :votable => configuration[:votable])
    v.update_attribute(:score, configuration[:score])
    return v
  end
  
  # Remove a vote, equivalent to Vote.add_vote(voter, votable, 0)
  def self.del_vote(voter, votable)
    self.find_by_voter_and_votable(voter, votable).try(:destroy)
  end
  
  private
  
  def increment_or_decrement_fan_count
    return unless votable.has_attribute?(:fan_count)
    if self.score > 0
      votable.increment!(:fan_count)
    else
      votable.decrement!(:fan_count)
    end
  end
  
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
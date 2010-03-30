class Vote < ActiveRecord::Base
  attr_accessible :voter_sex, :score, :voter, :votable
  
  after_create :after_create_fan_count
  after_update :after_update_fan_count
  after_destroy :after_destroy_fan_count
  
  belongs_to :votable, :polymorphic => true, :counter_cache => true
  belongs_to :voter, :class_name => "User"
  
  validates_presence_of :voter_id, :votable_id, :votable_type
  validates_uniqueness_of :votable_id, :scope => [:votable_type, :voter_id]
  
  named_scope :for_voter,    lambda { |*args| {:conditions => ["voter_id = ?", args.first.id]} }
  named_scope :for_votable, lambda { |*args| {:conditions => ["votable_id = ? AND votable_type = ?", args.first.id, args.first.class.name]} }
  named_scope :for_votable_class, lambda { |*args| {:conditions => ['votable_type = ?', args.first.name]}}
  named_scope :positive_score, :conditions => ['score > ?', 0]
  named_scope :negative_score, :conditions => ['score < ?', 0]
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
  
  # fan_count callback
  def after_destroy_fan_count
    increment_or_decrement_fan_count!(self.score, 0)
  end
  
  def after_create_fan_count
    increment_or_decrement_fan_count!(0, self.score)
  end
  
  def after_update_fan_count
    changed_attributes = self.send(:changed_attributes)
    increment_or_decrement_fan_count!(changed_attributes['score'], self.score) if changed_attributes['score']
  end
  
  # dirty looking method but quite simple in fact :
  #
  #                | score > 0 | score == 0 | score < 0 |
  # old_score > 0  |    0      |     -1     |     -1    |
  # old_score == 0 |   +1      |     0      |     0     |
  # old_score < 0  |   +1      |     0      |     0     |
  
  def increment_or_decrement_fan_count!(old_score, score)
    old_score, score = old_score.to_i, score.to_i
    return if (old_score * score) > 0 # both not null and same sign, we don't care
    
    # here, we can count on the fact that either score or old_score is not null
    if old_score > 0
      decrement_fan_count!
    elsif score > 0
      increment_fan_count!
    end
  end
  
  def increment_fan_count!
    return unless votable.has_attribute?(:fan_count)
    votable.increment!(:fan_count)
  end
  
  def decrement_fan_count!
    return unless votable.has_attribute?(:fan_count)
    votable.decrement!(:fan_count) if votable.fan_count > 0 # this prevents getting negative fan count
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
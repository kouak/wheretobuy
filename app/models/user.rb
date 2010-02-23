class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = 'email'
  end # block optional
  
  has_many :written_comments, :class_name => "Comments", :foreign_key => "author_id" # written comments
  has_many :sent_votes, :class_name => "Vote", :foreign_key => "voter_id"
  has_many :comments, :as => :resource
  belongs_to :city
  belongs_to :country

  attr_accessible :comments_count
  attr_accessible :email, :username, :password, :password_confirmation, :old_password, :country_id, :city_name
  attr_accessor :validates_password_change, :old_password, :city_name
  
  validates_uniqueness_of :username
  validates_length_of :username, :in => 2..30, :allow_nil => true, :allow_blank => true
  
  before_validation :set_city_id
  
  
  # validates password change from account page
  
  validate_on_update do |record|
    if record.validates_password_change
      unless record.password.blank? and record.password_confirmation.blank? and record.old_password.blank?
        record.errors.add :old_password, 'Current password does not match' unless record.valid_password?(record.old_password)
      end
    end
  end
  
  def active?
    active
  end
  
  def activate!
    self.active = true
    save
  end
  
  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  def to_s
    if username.blank?
      return email
    end
    username
  end
  
  def validate_password= (a)
    self.class.ignore_blank_passwords = a
  end
  
  def city_name
    self.city.try(:to_s)
  end
  
  def set_city_id
    country = Country.find(country_id) unless (country_id.nil? || country_id == 0)
    self.city_id = country.cities.find_or_create_by_name(@city_name).id unless country.nil?
  end
  
  def vote_for(votable)
    vote_for_with_score(votable, 1)
  end
  
  def vote_against(votable)
    vote_for_with_score(votable, -1)
  end
  
  def vote_nil(votable)
    Vote.find(:first, :conditions => [
      "voter_id = ? AND votable_id = ? AND votable_type = ?", 
      self.id, votable.id, votable.class.name]
    ).destroy
  end
  
  def voted_for?(votable)
    0 < Vote.count(:all, :conditions => 
      [
        "voter_id = ? AND score > 0 AND votable_id = ? AND votable_type = ?",
        self.id, votable.id, votable.class.name
      ]
    )
  end

  def voted_against?(votable)
    0 < Vote.count(:all, :conditions => 
      [
        "voter_id = ? AND score < 0 AND votable_id = ? AND votable_type = ?",
        self.id, votable.id, votable.class.name
      ]
    )
  end
  
  def voted_on?(votable)
    0 < Vote.count(:all, :conditions => 
      [
        "voter_id = ? AND votable_id = ? AND votable_type = ?",
        self.id, votable.id, votable.class.name
      ]
    )
  end
  
  private
  def vote_for_with_score(votable, score)
    raise ArgumentError, "votable not defined" unless votable.respond_to?(:votes)
    raise ArgumentError, "score = 0" if score.to_i == 0
    
    @vote = votable.votes.find(:first, :conditions => {:voter_id => self.id})
    if @vote.nil?
      @vote = Vote.create(:score => score, :voter => self, :votable => votable)
    else
      @vote.score = score
      @vote.save
    end
  end
end

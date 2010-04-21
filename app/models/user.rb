require 'lib/votes/acts_as_voter'
class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = 'email'
  end # block optional
  
  # Sex field constants
  MALE = false
  FEMALE = true
  
  has_many :written_comments, :class_name => "Comment", :foreign_key => "author_id" # written comments
  has_many :brand_wiki_editions, :class_name => "BrandWiki", :foreign_key => "editor_id"
  has_many :comments, :as => :resource
  belongs_to :city
  belongs_to :country
  
  has_many :friendships, :dependent => :destroy
  has_many :friends, :through => :friendships
  has_many :approved_friends, :source => :friend, :through => :approved_friendships
  
  has_many :approved_friendships, :class_name => 'Friendship', :conditions => ["state = ?", 'approved']
  
  has_many :reverse_friendships, :dependent => :destroy, :foreign_key => "friend_id", :class_name => "Friendship"
  has_many :reverse_friends, :through => :reverse_friendships, :source => :user
  

  attr_accessible :comments_count
  attr_accessible :email, :username, :password, :password_confirmation, :old_password, :country_id, :city_name, :sex
  attr_accessor :validates_password_change, :old_password, :city_name
  
  validates_uniqueness_of :username
  validates_length_of :username, :in => 2..30
  validates_inclusion_of :sex, :in => [true, false]
  
  before_validation :set_city_id
  
  acts_as_voter
  acts_as_tagger
  
  
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
    update_attributes!(:active => true)
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
    username
  end
  
  def to_param
    id.to_s+'-'+ActiveSupport::Inflector.parameterize(to_s)
  end
  
  def validate_password= (a)
    self.class.ignore_blank_passwords = a
  end
  
  def city_name
    self.city.try(:to_s)
  end
  
  def country_name
    self.city.try(:country).try(:to_s)
  end
  
  def set_city_id
    country = Country.find(country_id) unless (country_id.nil? || country_id == 0)
    self.city_id = country.cities.find_or_create_by_name(@city_name).id unless country.nil?
  end
  
  def request_friendship_with(friend)
    raise ArgumentError unless friend.is_a?(User)
    self.friendships.new(:friend_id => friend.id)
  end
  
  def is_friend_with?(friend)
    self.approved_friends.include?(friend)
  end
  
  def can_request_friendship?(friend)
    
    return Friendship.requestable_between?(self, friend)
    
    # an user can request friendship only if there are no pending friendship requests between those 2 users and if he's not connected with the friend already
    preventive_friendships = (self.friendships + self.reverse_friendships).reject { |fr| # look through all friendships linked to this user
      if fr.pending?
        ![[self.id, friend.id], [friend.id, self.id]].include?([fr.user_id, fr.friend_id]) # keep (return false) if some kind of friendship has been requested between those guys
      elsif fr.approved?
        !(fr.user_id == self.id && fr.friend_id == friend.id) # keep if this one already exist
      end
    }
    
    return preventive_friendships.empty?
    
    return self.friendships.new(:friend_id => friend.try(:id)).valid?
  end
end

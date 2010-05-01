require 'lib/votes/acts_as_voter'
class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = :email
    c.validate_login_field = false
  end # block optional
  
  # Sex field constants
  MALE = false
  FEMALE = true
  
  has_many :written_comments, :class_name => "Comment", :foreign_key => "author_id" # written comments
  has_many :created_brands, :class_name => 'Brand', :foreign_key => 'creator_id'
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
  
  has_many :sent_activities, :class_name => 'Activity', :dependent => :destroy
  

  attr_accessible :comments_count
  attr_accessible :email, :username, :password, :password_confirmation, :current_password, :country_id, :city_name, :sex, :birthday, :email_confirmation
  attr_accessor :skip_current_password_validation, :current_password, :city_name
  
  validates_presence_of :username
  validates_presence_of :email
  validates_confirmation_of :email
  
  validates_presence_of :password, :on => :create
  validates_presence_of :password_confirmation, :on => :create
  
  validates_uniqueness_of :username
  validates_length_of :username, :in => 2..30
  validates_inclusion_of :sex, :in => [true, false]
  
  validates_date :birthday, :allow_blank => true, :allow_nil => true, :before => Time.now
  
  
  before_validation :set_city_id
  
  acts_as_voter
  acts_as_tagger
  
  # verify password changes against current password
  validate_on_update do |record|
    if record.skip_current_password_validation == false # We can bypass this validation in the case of password resets or admin edition
      if record.send(:password_changed?) || record.send(:email_changed?)
        record.errors.add :current_password, 'Current password does not match' unless record.valid_password?(record.current_password)
      end
    end
  end

  
  def tag_with_activity_log(target, opts = {})
    
    taglist = TagList.from(opts[:with])
    
    if taglist.count > 0
      a = Activity.tagged(target, taglist, self)
      raise Exceptions::ActivityError unless a.save
    end
    
    tag_without_activity_log(target, opts)
  end
  
  alias_method_chain :tag, :activity_log
  
  def active?
    active
  end
  
  def skip_current_password_validation
    @skip_current_password_validation == true
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
  
  def city_name
    self.city.try(:to_s)
  end
  
  def country_name
    self.country.try(:to_s)
  end
  
  # Return the age using the birthdate.
  def age(today = nil)
    today = today ? Date.parse(today) : Date.today
    return nil if birthday.nil? || birthday > today
    if (today.month > birthday.month) or (today.month == birthday.month and today.day >= birthday.day)
      # Birthday has happened already this year.
      today.year - birthday.year
    else
      today.year - birthday.year - 1
    end
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

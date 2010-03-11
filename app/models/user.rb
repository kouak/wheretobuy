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

  attr_accessible :comments_count
  attr_accessible :email, :username, :password, :password_confirmation, :old_password, :country_id, :city_name, :sex
  attr_accessor :validates_password_change, :old_password, :city_name
  
  validates_uniqueness_of :username
  validates_length_of :username, :in => 2..30
  validates_inclusion_of :sex, :in => [true, false]
  
  before_validation :set_city_id
  
  acts_as_voter
  
  
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
end

class City < ActiveRecord::Base
  attr_accessible :name, :country_id
  belongs_to :country
  has_many :users
  
  validates_presence_of :name
  validate :ensure_country_exists
  
  named_scope :featured,
    :limit => 5,
    :joins => [:users],
    :select => "cities.*, count(users.id) as activity",
    :order => "activity DESC",
    :group => "users.city_id"

  def ensure_country_exists
    errors.add('Country') unless Country.find_by_id(self.country_id)
  end
  
  def to_s
    name
  end
end

class Country < ActiveRecord::Base
  attr_accessible :name
  has_many :stores
  has_many :cities
  
  
  # friendly urls
  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end
  
  def to_s
    name
  end
end

class BrandType < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :brands
  
  validates_length_of :name, :in => 1..25
end

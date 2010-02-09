class Brand < ActiveRecord::Base
  attr_accessible :name, :url
  
  validates_presence_of :name
  validates_length_of :name, :in => 2..70
  
  validates_format_of :url, :with => /^(http):\/\/.*/, :allow_nil => true, :allow_blank => true
end

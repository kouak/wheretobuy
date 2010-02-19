class Store < ActiveRecord::Base
  attr_accessible :name, :url, :address, :city_id, :online_shop
  belongs_to :city
  belongs_to :country
end

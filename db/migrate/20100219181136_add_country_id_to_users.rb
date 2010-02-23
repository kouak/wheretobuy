class AddCountryIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :country_id, :integer, :default => 0
    User.all.each do |u|
      if !u.try(:city).try(:country).nil?
        # if we have a city, use this as country id
        u.country_id = u.city.country.id
        u.save!
      end
    end
  end

  def self.down
    remove_column :users, :country_id
  end
end

class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :name
      t.string :url
      t.string :address
      t.integer :city_id
      t.integer :country_id
      t.float :latitude
      t.float :longitude
      t.boolean :online_shop, :default => true
      t.timestamps
    end
  end
  
  def self.down
    drop_table :stores
  end
end

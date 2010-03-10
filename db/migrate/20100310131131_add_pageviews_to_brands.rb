class AddPageviewsToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :pageviews, :integer, :default => 0
  end

  def self.down
    remove_column :brands, :pageviews
  end
end

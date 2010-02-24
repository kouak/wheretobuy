class RemoveUrlFromBrands < ActiveRecord::Migration
  def self.up
    remove_column :brands, :url
  end

  def self.down
    add_column :brands, :url, :string
  end
end

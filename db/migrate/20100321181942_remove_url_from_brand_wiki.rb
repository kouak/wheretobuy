class RemoveUrlFromBrandWiki < ActiveRecord::Migration
  def self.up
    remove_column :brand_wikis, :url
  end

  def self.down
    add_column :brand_wikis, :url, :string
  end
end

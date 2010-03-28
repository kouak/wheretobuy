class AddFactboxCacheToBrandWiki < ActiveRecord::Migration
  def self.up
    add_column :brand_wikis, :factbox_cache, :text
  end

  def self.down
    remove_column :brand_wikis, :factbox_cache
  end
end

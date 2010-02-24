class AddEditorIdToBrandWiki < ActiveRecord::Migration
  def self.up
    add_column :brand_wikis, :editor_id, :integer
  end

  def self.down
    remove_column :brand_wikis, :editor_id
  end
end

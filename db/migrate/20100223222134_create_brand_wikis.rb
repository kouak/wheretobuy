class CreateBrandWikis < ActiveRecord::Migration
  def self.up
    create_table :brand_wikis do |t|
      t.integer :brand_id
      t.text :version_comment
      t.text :bio
      t.string :url
      t.timestamps
    end
  end
  
  def self.down
    drop_table :brand_wikis
  end
end

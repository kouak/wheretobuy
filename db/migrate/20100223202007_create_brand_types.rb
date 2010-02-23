class CreateBrandTypes < ActiveRecord::Migration
  def self.up
    create_table :brand_types do |t|
      t.string :name
      t.timestamps
    end
  end
  
  def self.down
    drop_table :brand_types
  end
end

class CreateBrandsBrandTypesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :brands_brand_types, :id => false do |t|
      t.integer :brand_id
      t.integer :brand_type_id
    end
  end

  def self.down
    drop_table :brands_brand_types
  end
end

class RenameTableBrandBrandTypesJoinTable < ActiveRecord::Migration
  def self.up
    rename_table :brands_brand_types, :brand_types_brands
  end

  def self.down
    rename_table :brand_types_brands, :brands_brand_types
  end
end

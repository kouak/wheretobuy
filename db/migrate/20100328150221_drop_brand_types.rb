class DropBrandTypes < ActiveRecord::Migration
  def self.up
    drop_table :brand_types
    drop_table :brand_types_brands
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can't recover brand_types"
  end
end

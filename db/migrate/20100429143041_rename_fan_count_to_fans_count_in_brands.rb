class RenameFanCountToFansCountInBrands < ActiveRecord::Migration
  def self.up
    rename_column :brands, :fan_count, :fans_count
  end

  def self.down
    rename_column :brands, :fans_count, :fan_count
  end
end

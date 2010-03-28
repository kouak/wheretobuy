class AddFanCountToBrand < ActiveRecord::Migration
  def self.up
    add_column :brands, :fan_count, :integer, :default => 0
    Brand.all.each do |brand|
      brand.update_attributes!(:fan_count => brand.fans.count)
    end
  end

  def self.down
    remove_column :brands, :fan_count
  end
end

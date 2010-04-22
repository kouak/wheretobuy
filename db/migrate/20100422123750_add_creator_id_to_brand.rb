class AddCreatorIdToBrand < ActiveRecord::Migration
  def self.up
    add_column :brands, :creator_id, :integer
  end

  def self.down
    remove_column :brands, :creator_id
  end
end

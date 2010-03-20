class AddVotesCountToBrand < ActiveRecord::Migration
  def self.up
    add_column :brands, :votes_count, :integer, :default => 0
  end

  def self.down
    remove_column :brands, :votes_count
  end
end

class RenameStatusToStateInFriendships < ActiveRecord::Migration
  def self.up
    rename_column :friendships, :status, :state
  end

  def self.down
    rename_column :friendships, :state, :status
  end
end

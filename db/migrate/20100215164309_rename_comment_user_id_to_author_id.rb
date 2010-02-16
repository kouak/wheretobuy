class RenameCommentUserIdToAuthorId < ActiveRecord::Migration
  def self.up
    rename_column :comments, :user_id, :author_id
  end

  def self.down
    rename_column :comments, :author_id, :user_id
  end
end

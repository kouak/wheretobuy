class AddCommentsCountToUsersAndBrands < ActiveRecord::Migration
  def self.up
    add_column :users, :comments_count, :integer
    add_column :brands, :comments_count, :integer
    User.all.each do |u|
      u.comments_count = u.comments.count
    end
    Brand.all.each do |b|
      b.comments_count = b.comments.count
    end
  end

  def self.down
    remove_column :users, :comments_count
    remove_column :brands, :comments_count
  end
end

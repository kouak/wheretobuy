class AddSexToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :sex, :boolean, :default => false # false = man, true = woman
  end

  def self.down
    remove_column :users, :sex
  end
end

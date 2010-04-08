class AddTimestampsToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.timestamps
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :created_at, :updated_at
    end
  end
end

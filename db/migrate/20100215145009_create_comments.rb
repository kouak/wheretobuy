class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :user_id
      t.integer :status
      t.text :body
      t.integer :resource_id
      t.string :resource_type
      t.timestamps
    end
  end
  
  def self.down
    drop_table :comments
  end
end

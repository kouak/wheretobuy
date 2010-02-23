class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :voter_id
      t.integer :voter_sex
      t.integer :votable_id
      t.string :votable_type
      t.integer :score
      t.timestamps
    end
  end
  
  def self.down
    drop_table :votes
  end
end

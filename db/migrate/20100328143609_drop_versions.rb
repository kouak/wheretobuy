class DropVersions < ActiveRecord::Migration
  def self.up
    drop_table :versions
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Please use VestalVersions"
  end
end

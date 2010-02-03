
class InitialMigration < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string   "email",                              :null => false
      t.string   "crypted_password",                   :null => false
      t.string   "password_salt",                      :null => false
      t.string   "persistence_token",                  :null => false
      t.string   "single_access_token",                :null => false
      t.string   "perishable_token",                   :null => false
      t.integer  "login_count",         :default => 0, :null => false
      t.integer  "failed_login_count",  :default => 0, :null => false
      t.datetime "last_request_at"
      t.datetime "current_login_at"
      t.datetime "last_login_at"
      t.string   "current_login_ip"
      t.string   "last_login_ip"
      t.string   "username"
      t.boolean  "active"
    end
    add_index :users, :email, :unique => true
    add_index :users, :perishable_token, :unique => true
  end

  def self.down
  end
end

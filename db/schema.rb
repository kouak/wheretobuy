# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100429143041) do

  create_table "activities", :force => true do |t|
    t.integer  "author_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brand_wiki_versions", :force => true do |t|
    t.integer  "brand_wiki_id"
    t.integer  "version"
    t.integer  "brand_id"
    t.text     "version_comment"
    t.text     "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "editor_id"
    t.text     "factbox_cache"
  end

  add_index "brand_wiki_versions", ["brand_wiki_id"], :name => "index_brand_wiki_versions_on_brand_wiki_id"

  create_table "brand_wikis", :force => true do |t|
    t.integer  "brand_id",        :null => false
    t.text     "version_comment"
    t.text     "bio",             :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "editor_id"
    t.text     "factbox_cache"
    t.integer  "version"
  end

  create_table "brands", :force => true do |t|
    t.string   "name",                          :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "comments_count", :default => 0, :null => false
    t.integer  "pageviews",      :default => 0, :null => false
    t.integer  "votes_count",    :default => 0, :null => false
    t.integer  "fans_count",     :default => 0
    t.integer  "creator_id"
  end

  create_table "cities", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "country_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "author_id"
    t.integer  "status"
    t.text     "body",          :null => false
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "friendships", :force => true do |t|
    t.string   "state"
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stores", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "url"
    t.string   "address"
    t.integer  "city_id"
    t.integer  "country_id"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "online_shop", :default => true, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "username"
    t.boolean  "active"
    t.integer  "comments_count"
    t.integer  "city_id"
    t.integer  "country_id"
    t.boolean  "sex",                 :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "birthday"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "voter_id"
    t.integer  "voter_sex"
    t.integer  "votable_id",   :null => false
    t.string   "votable_type", :null => false
    t.integer  "score",        :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end

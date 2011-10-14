# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111013155303) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["followed_id"], :name => "index_invitations_on_followed_id"
  add_index "invitations", ["follower_id", "followed_id"], :name => "index_invitations_on_follower_id_and_followed_id", :unique => true
  add_index "invitations", ["follower_id"], :name => "index_invitations_on_follower_id"

  create_table "motivations", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "motivations", ["title"], :name => "index_motivations_on_title", :unique => true

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.datetime "sent_at"
    t.text     "at_who"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "token_types", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "token_types", ["title"], :name => "index_token_types_on_title", :unique => true

  create_table "tokens", :force => true do |t|
    t.integer  "token_type_id"
    t.integer  "user_id"
    t.integer  "motivation_id"
    t.integer  "checkin_owner_id"
    t.integer  "token_owner_id"
    t.decimal  "cost",             :precision => 10, :scale => 2, :default => 0.0
    t.datetime "start_at"
    t.datetime "stop_at"
    t.boolean  "used",                                            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tokens", ["checkin_owner_id"], :name => "index_tokens_on_checkin_owner_id"
  add_index "tokens", ["motivation_id"], :name => "index_tokens_on_motivation_id"
  add_index "tokens", ["token_owner_id"], :name => "index_tokens_on_token_owner_id"
  add_index "tokens", ["token_type_id"], :name => "index_tokens_on_token_type_id"
  add_index "tokens", ["user_id"], :name => "index_tokens_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "gender",                                :default => "Mr"
    t.string   "company"
    t.string   "phone"
    t.string   "twitter"
    t.text     "bio"
    t.boolean  "admin",                                 :default => false
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "checkin_label_msg"
    t.boolean  "process_done",                          :default => false
    t.string   "username"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["firstname"], :name => "index_users_on_firstname"
  add_index "users", ["lastname"], :name => "index_users_on_lastname"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

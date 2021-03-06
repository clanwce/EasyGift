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

ActiveRecord::Schema.define(:version => 20140802031906) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "business_account_tags", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "business_account_tags", ["user_id", "tag_id"], :name => "index_business_account_tags_on_user_id_and_tag_id", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "gift_request_id"
    t.text     "description"
    t.integer  "like_count",      :default => 0
    t.integer  "dislike_count",   :default => 0
    t.boolean  "final_answer"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "conversations", :force => true do |t|
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "last_message_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "gift_request_black_lists", :force => true do |t|
    t.integer  "gift_request_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "gift_request_white_lists", :force => true do |t|
    t.integer  "gift_request_id"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "gift_requests", :force => true do |t|
    t.integer  "user_id"
    t.text     "description"
    t.integer  "like_count",    :default => 0
    t.integer  "dislike_count", :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "title"
    t.integer  "views",         :default => 0
    t.boolean  "private_post",  :default => false
  end

  create_table "gift_requests_tags", :force => true do |t|
    t.integer  "gift_request_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "gift_requests_tags", ["gift_request_id", "tag_id"], :name => "index_gift_requests_tags_on_gift_request_id_and_tag_id", :unique => true

  create_table "likes", :force => true do |t|
    t.string   "status"
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "gift_request_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "type_of_event"
    t.integer  "event_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "actor_id"
  end

  create_table "private_messages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.text     "message"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "gift_request_count", :default => 0
  end

  create_table "user_conversations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.boolean  "deleted",         :default => false
    t.boolean  "read",            :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.datetime "last_delete_at"
  end

  add_index "user_conversations", ["user_id", "conversation_id"], :name => "index_user_conversations_on_user_id_and_conversation_id", :unique => true

  create_table "user_notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "notification_id"
    t.boolean  "read",            :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "message"
  end

  add_index "user_notifications", ["user_id", "notification_id"], :name => "index_user_notifications_on_user_id_and_notification_id", :unique => true

  create_table "user_views", :force => true do |t|
    t.integer  "user_id"
    t.integer  "gift_request_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "user_views", ["user_id", "gift_request_id"], :name => "index_user_views_on_user_id_and_gift_request_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",      :null => false
    t.string   "encrypted_password",     :default => "",      :null => false
    t.string   "username"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,       :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "points",                 :default => 1000
    t.string   "rank",                   :default => "Stone"
    t.boolean  "business_account",       :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end

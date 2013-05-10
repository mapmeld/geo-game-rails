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

ActiveRecord::Schema.define(:version => 20130501172500) do

  create_table "instagram_photos", :force => true do |t|
    t.string   "created_time"
    t.string   "instagram_photo_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "image_url"
    t.text     "caption"
    t.integer  "instagram_user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "category_id"
    t.integer  "score"
    t.integer  "likes"
  end

  add_index "instagram_photos", ["instagram_user_id"], :name => "index_instagram_photos_on_instagram_user_id"
  add_index "instagram_photos", ["category_id"], :name => "index_instagram_photos_on_category_id"

  create_table "instagram_users", :force => true do |t|
    t.string   "username"
    t.string   "profile_picture"
    t.string   "instagram_id"
    t.string   "full_name"
    t.integer  "score"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "tag"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

end

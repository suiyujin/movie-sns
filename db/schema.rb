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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150522080534) do

  create_table "ajax_tests", force: true do |t|
    t.string   "movie_id"
    t.string   "title"
    t.string   "description"
    t.string   "url"
    t.string   "thumbnail_url"
    t.string   "thumbnail_path"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ajax_tests", ["user_id"], name: "index_ajax_tests_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.string "name"
  end

  create_table "movies", force: true do |t|
    t.string   "movie_id"
    t.string   "title"
    t.string   "description"
    t.string   "url"
    t.string   "thumbnail_url"
    t.string   "thumbnail_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nicovideo_categories", force: true do |t|
    t.string  "name"
    t.integer "category_id"
  end

  add_index "nicovideo_categories", ["category_id"], name: "index_nicovideo_categories_on_category_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   default: "名称未設定", null: false
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "youtube_categories", force: true do |t|
    t.string  "name"
    t.integer "category_id"
  end

  add_index "youtube_categories", ["category_id"], name: "index_youtube_categories_on_category_id", using: :btree

end

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

ActiveRecord::Schema.define(version: 20150523023402) do

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

  create_table "comments", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "movies", force: true do |t|
    t.string   "movie_id"
    t.string   "title"
    t.text     "description"
    t.string   "url"
    t.string   "thumbnail_url"
    t.string   "thumbnail_path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id",    null: false
    t.integer  "user_id",        null: false
  end

  add_index "movies", ["category_id"], name: "index_movies_on_category_id", using: :btree
  add_index "movies", ["user_id"], name: "index_movies_on_user_id", using: :btree

  create_table "nicovideo_categories", force: true do |t|
    t.string  "name"
    t.integer "category_id"
  end

  add_index "nicovideo_categories", ["category_id"], name: "index_nicovideo_categories_on_category_id", using: :btree

  create_table "relations", force: true do |t|
    t.float    "similarity", limit: 24, default: 0.0, null: false
    t.integer  "movie1_id",                           null: false
    t.integer  "movie2_id",                           null: false
    t.integer  "user_id",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relations", ["movie1_id"], name: "index_relations_on_movie1_id", using: :btree
  add_index "relations", ["movie2_id"], name: "index_relations_on_movie2_id", using: :btree
  add_index "relations", ["user_id"], name: "index_relations_on_user_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

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

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  create_table "youtube_categories", force: true do |t|
    t.string  "name"
    t.integer "category_id"
    t.integer "youtube_category_id"
  end

  add_index "youtube_categories", ["category_id"], name: "index_youtube_categories_on_category_id", using: :btree

end

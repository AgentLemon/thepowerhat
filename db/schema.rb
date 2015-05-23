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

ActiveRecord::Schema.define(version: 20150220125204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "budget", force: true do |t|
    t.integer  "user_id"
    t.decimal  "amount"
    t.string   "comment"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debts", force: true do |t|
    t.integer  "who_id"
    t.integer  "whom_id"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "debts", ["who_id"], name: "index_debts_on_who_id", using: :btree
  add_index "debts", ["whom_id"], name: "index_debts_on_whom_id", using: :btree

  create_table "images", force: true do |t|
    t.integer  "post_id"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parties", force: true do |t|
    t.string   "title"
    t.datetime "date"
    t.integer  "leader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "party_members", force: true do |t|
    t.integer  "user_id"
    t.integer  "party_id"
    t.decimal  "debt"
    t.decimal  "paid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "party_members", ["party_id"], name: "index_party_members_on_party_id", using: :btree
  add_index "party_members", ["user_id"], name: "index_party_members_on_user_id", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "secured_messages", force: true do |t|
    t.text     "encrypted_message"
    t.string   "salt"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_links", force: true do |t|
    t.integer "link_id"
    t.integer "tag_id"
    t.string  "link_type"
  end

  add_index "tag_links", ["link_id"], name: "index_tag_links_on_link_id", using: :btree
  add_index "tag_links", ["link_type"], name: "index_tag_links_on_link_type", using: :btree
  add_index "tag_links", ["tag_id"], name: "index_tag_links_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["user_id"], name: "index_tags_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "role"
    t.string   "avatar"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "github_uid"
  end

  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree

end

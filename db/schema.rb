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

ActiveRecord::Schema.define(version: 20151031050252) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "budget", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "amount"
    t.string   "comment",    limit: 255
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debts", force: :cascade do |t|
    t.integer  "who_id"
    t.integer  "whom_id"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "debts", ["who_id"], name: "index_debts_on_who_id", using: :btree
  add_index "debts", ["whom_id"], name: "index_debts_on_whom_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "post_id"
    t.string   "file",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parties", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "date"
    t.integer  "leader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "party_members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "party_id"
    t.decimal  "debt"
    t.decimal  "paid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "party_members", ["party_id"], name: "index_party_members_on_party_id", using: :btree
  add_index "party_members", ["user_id"], name: "index_party_members_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title",      limit: 255
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "secured_messages", force: :cascade do |t|
    t.text     "encrypted_message"
    t.string   "salt",              limit: 255
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_links", force: :cascade do |t|
    t.integer "link_id"
    t.integer "tag_id"
    t.string  "link_type", limit: 255
  end

  add_index "tag_links", ["link_id"], name: "index_tag_links_on_link_id", using: :btree
  add_index "tag_links", ["link_type"], name: "index_tag_links_on_link_type", using: :btree
  add_index "tag_links", ["tag_id"], name: "index_tag_links_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["user_id"], name: "index_tags_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                        limit: 255
    t.string   "crypted_password",             limit: 255
    t.string   "salt",                         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token",            limit: 255
    t.datetime "remember_me_token_expires_at"
    t.string   "role",                         limit: 255
    t.string   "avatar",                       limit: 255
    t.string   "last_name",                    limit: 255
    t.string   "first_name",                   limit: 255
    t.string   "github_uid",                   limit: 255
  end

  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree

end

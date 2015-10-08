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

ActiveRecord::Schema.define(version: 8) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invites", force: :cascade do |t|
    t.integer  "users_id"
    t.integer  "from_user_id"
    t.string   "key"
    t.integer  "created_user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "invites", ["created_user_id"], name: "index_invites_on_created_user_id", using: :btree
  add_index "invites", ["from_user_id"], name: "index_invites_on_from_user_id", using: :btree
  add_index "invites", ["key"], name: "index_invites_on_key", unique: true, using: :btree
  add_index "invites", ["users_id"], name: "index_invites_on_users_id", using: :btree

  create_table "nodes", force: :cascade do |t|
    t.integer  "users_id"
    t.integer  "author_id"
    t.string   "namespace"
    t.string   "name"
    t.string   "noun_type"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "nodes", ["author_id"], name: "index_nodes_on_author_id", using: :btree
  add_index "nodes", ["name"], name: "index_nodes_on_name", using: :btree
  add_index "nodes", ["namespace", "name", "author_id"], name: "index_nodes_on_namespace_and_name_and_author_id", unique: true, using: :btree
  add_index "nodes", ["namespace"], name: "index_nodes_on_namespace", using: :btree
  add_index "nodes", ["users_id"], name: "index_nodes_on_users_id", using: :btree

  create_table "presences", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "namespace"
    t.string   "name"
    t.string   "previous_namespace"
    t.string   "previous_name"
    t.string   "verbing"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "presences", ["user_id"], name: "index_presences_on_user_id", unique: true, using: :btree

  create_table "softlinks", force: :cascade do |t|
    t.string   "namespace",              null: false
    t.string   "from_name",              null: false
    t.string   "to_name",                null: false
    t.integer  "traversals", default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "softlinks", ["namespace", "from_name", "to_name"], name: "index_softlinks_on_namespace_and_from_name_and_to_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree

  add_foreign_key "invites", "users", column: "created_user_id"
  add_foreign_key "invites", "users", column: "from_user_id"
  add_foreign_key "nodes", "users", column: "author_id"
  add_foreign_key "presences", "users"
end

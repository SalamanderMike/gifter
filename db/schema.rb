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

ActiveRecord::Schema.define(version: 20140922215021) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auto_completes", force: true do |t|
    t.string   "cuisine"
    t.string   "shops"
    t.string   "services"
    t.string   "booksGenre"
    t.string   "musicGenre"
    t.string   "toys"
    t.string   "hobbies"
    t.string   "clothes"
    t.string   "art"
    t.string   "color"
    t.string   "animals"
    t.string   "metal"
    t.string   "element"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "eventName"
    t.string   "password"
    t.integer  "admin_id"
    t.integer  "participants"
    t.integer  "spendingLimit"
    t.text     "match",         array: true
    t.date     "expire"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.integer  "zip"
    t.text     "cuisine",    array: true
    t.text     "shops",      array: true
    t.text     "services",   array: true
    t.text     "bookGenre",  array: true
    t.text     "musicGenre", array: true
    t.text     "clothes",    array: true
    t.text     "color",      array: true
    t.text     "animal",     array: true
    t.text     "metal",      array: true
    t.text     "element",    array: true
    t.text     "art",        array: true
    t.text     "hobbies",    array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_events", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_events", ["event_id"], name: "index_users_events_on_event_id", using: :btree
  add_index "users_events", ["user_id"], name: "index_users_events_on_user_id", using: :btree

end

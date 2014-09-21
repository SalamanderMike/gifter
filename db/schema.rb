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

ActiveRecord::Schema.define(version: 20140921035548) do

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
    t.string   "groupID"
    t.string   "participants"
    t.integer  "spendingLimit"
    t.date     "expire"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "firstName"
    t.string   "lastName"
    t.string   "username"
    t.string   "password_digest"
    t.integer  "zip"
    t.string   "match"
    t.string   "purchase"
    t.string   "personality"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

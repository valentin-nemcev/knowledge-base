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

ActiveRecord::Schema.define(version: 20160310121500) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "current_revision_id"
    t.datetime "destroyed_at"
  end

  add_index "articles", ["current_revision_id"], name: "index_articles_on_current_revision_id", using: :btree
  add_index "articles", ["destroyed_at"], name: "index_articles_on_destroyed_at", using: :btree

  create_table "reviews", force: :cascade do |t|
    t.datetime "reviewed_at",      null: false
    t.integer  "article_id"
    t.integer  "response_quality"
  end

  add_index "reviews", ["article_id"], name: "index_reviews_on_article_id", using: :btree

  create_table "revisions", force: :cascade do |t|
    t.integer  "article_id"
    t.string   "title",                      null: false
    t.text     "body",                       null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "autosave",   default: false, null: false
  end

  add_index "revisions", ["article_id"], name: "index_revisions_on_article_id", using: :btree

  add_foreign_key "articles", "revisions", column: "current_revision_id"
  add_foreign_key "reviews", "articles"
  add_foreign_key "revisions", "articles"
end

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

ActiveRecord::Schema.define(version: 20160125134225) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_reviews", force: :cascade do |t|
    t.datetime "reviewed_at"
    t.integer  "article_id"
  end

  add_index "article_reviews", ["article_id"], name: "index_article_reviews_on_article_id", using: :btree

  create_table "article_revisions", force: :cascade do |t|
    t.integer  "article_id"
    t.string   "title",                      null: false
    t.text     "body",                       null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "autosave",   default: false, null: false
  end

  add_index "article_revisions", ["article_id"], name: "index_article_revisions_on_article_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "current_revision_id"
  end

  add_index "articles", ["current_revision_id"], name: "index_articles_on_current_revision_id", using: :btree

  add_foreign_key "article_reviews", "articles"
  add_foreign_key "article_revisions", "articles"
  add_foreign_key "articles", "article_revisions", column: "current_revision_id"
end

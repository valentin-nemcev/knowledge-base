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

ActiveRecord::Schema.define(version: 20160519093647) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_revisions", force: :cascade do |t|
    t.integer  "article_id",                      null: false
    t.string   "title",                           null: false
    t.text     "body",                            null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "autosave",        default: false, null: false
    t.string   "markup_language",                 null: false
    t.text     "body_html",                       null: false
    t.string   "card_ordering"
  end

  add_index "article_revisions", ["article_id"], name: "index_article_revisions_on_article_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "current_revision_id"
    t.datetime "destroyed_at"
  end

  add_index "articles", ["current_revision_id"], name: "index_articles_on_current_revision_id", using: :btree
  add_index "articles", ["destroyed_at"], name: "index_articles_on_destroyed_at", using: :btree

  create_table "card_revisions", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "card_id",                             null: false
    t.integer  "article_revision_id",                 null: false
    t.boolean  "autosave",            default: false, null: false
    t.text     "body_html",                           null: false
  end

  add_index "card_revisions", ["article_revision_id"], name: "index_card_revisions_on_article_revision_id", using: :btree
  add_index "card_revisions", ["card_id"], name: "index_card_revisions_on_card_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.string   "path",                null: false
    t.integer  "article_id",          null: false
    t.datetime "destroyed_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "current_revision_id"
  end

  add_index "cards", ["article_id"], name: "index_cards_on_article_id", using: :btree
  add_index "cards", ["current_revision_id"], name: "index_cards_on_current_revision_id", using: :btree
  add_index "cards", ["destroyed_at"], name: "index_cards_on_destroyed_at", using: :btree
  add_index "cards", ["path", "article_id"], name: "index_cards_on_path_and_article_id", unique: true, using: :btree

  create_table "reviews", force: :cascade do |t|
    t.datetime "reviewed_at", null: false
    t.integer  "card_id",     null: false
    t.string   "grade",       null: false
  end

  add_index "reviews", ["card_id"], name: "index_reviews_on_card_id", using: :btree

  add_foreign_key "article_revisions", "articles"
  add_foreign_key "articles", "article_revisions", column: "current_revision_id"
  add_foreign_key "card_revisions", "article_revisions"
  add_foreign_key "card_revisions", "cards"
  add_foreign_key "cards", "articles"
  add_foreign_key "cards", "card_revisions", column: "current_revision_id"
  add_foreign_key "reviews", "cards"
end

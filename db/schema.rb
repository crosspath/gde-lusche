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

ActiveRecord::Schema.define(version: 20140518135835) do

  create_table "addresses", force: true do |t|
    t.string   "name"
    t.integer  "type"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["parent_id"], name: "index_addresses_on_parent_id"

# Could not dump table "fts_addresses" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

# Could not dump table "fts_addresses_content" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "fts_addresses_docsize", primary_key: "docid", force: true do |t|
    t.binary "size"
  end

  create_table "fts_addresses_segdir", primary_key: "level", force: true do |t|
    t.integer "idx"
    t.integer "start_block"
    t.integer "leaves_end_block"
    t.integer "end_block"
    t.binary  "root"
  end

  add_index "fts_addresses_segdir", ["level", "idx"], name: "sqlite_autoindex_fts_addresses_segdir_1", unique: true

  create_table "fts_addresses_segments", primary_key: "blockid", force: true do |t|
    t.binary "block"
  end

  create_table "fts_addresses_stat", force: true do |t|
    t.binary "value"
  end

  create_table "houses", force: true do |t|
    t.string   "name"
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "houses", ["address_id"], name: "index_houses_on_address_id"

end

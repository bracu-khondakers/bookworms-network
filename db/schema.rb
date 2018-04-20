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

ActiveRecord::Schema.define(version: 20160403064453) do

  create_table "authors", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "biography",  limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "author_id",  limit: 255
  end

  create_table "authors_books", id: false, force: :cascade do |t|
    t.integer "author_id", limit: 4
    t.integer "book_id",   limit: 4
  end

  add_index "authors_books", ["author_id"], name: "index_authors_books_on_author_id", using: :btree
  add_index "authors_books", ["book_id"], name: "index_authors_books_on_book_id", using: :btree

  create_table "book_reviews", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "book_id",    limit: 4
    t.text     "review",     limit: 65535
    t.integer  "rating",     limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.boolean  "approved"
  end

  add_index "book_reviews", ["book_id"], name: "index_book_reviews_on_book_id", using: :btree
  add_index "book_reviews", ["user_id"], name: "index_book_reviews_on_user_id", using: :btree

  create_table "books", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.string   "isbn",         limit: 255
    t.string   "title",        limit: 255
    t.string   "genre",        limit: 255
    t.boolean  "availability"
    t.string   "condition",    limit: 255
    t.float    "market_price", limit: 24
    t.integer  "publisher_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "image",        limit: 255
  end

  add_index "books", ["publisher_id"], name: "index_books_on_publisher_id", using: :btree
  add_index "books", ["user_id"], name: "index_books_on_user_id", using: :btree

  create_table "deals", force: :cascade do |t|
    t.integer  "buyer_id",            limit: 4
    t.integer  "seller_id",           limit: 4
    t.integer  "book_id",             limit: 4
    t.date     "date_of_transaction"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "confirmed"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "donations", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "book_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.boolean  "accepted"
  end

  add_index "donations", ["book_id"], name: "index_donations_on_book_id", using: :btree
  add_index "donations", ["user_id"], name: "index_donations_on_user_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "address",    limit: 255
    t.float    "latitude",   limit: 24
    t.float    "longitude",  limit: 24
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "locations", ["user_id"], name: "index_locations_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "deal_id",    limit: 4
  end

  add_index "notifications", ["deal_id"], name: "fk_rails_51694c8465", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "privileges", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.boolean  "admin"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "privileges", ["user_id"], name: "index_privileges_on_user_id", using: :btree

  create_table "publishers", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "information",  limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "publisher_id", limit: 255
  end

  create_table "reviewerships", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "reviewer_id", limit: 4
    t.string   "rating",      limit: 255
    t.string   "review",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.boolean  "approved"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.date     "birth_date"
    t.text     "about_me",               limit: 65535
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "email",                  limit: 255,   default: "", null: false
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,     default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.string   "image",                  limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end

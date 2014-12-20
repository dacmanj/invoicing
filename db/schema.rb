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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141218233042) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "default_account_ar_account"
    t.integer  "contact_id"
    t.integer  "address_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "database_id"
    t.integer  "primary_contact_id"
  end

  create_table "addresses", :force => true do |t|
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "phone"
    t.string   "fax"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "contact_id"
    t.text     "address_lines"
  end

  create_table "codes", :force => true do |t|
    t.string   "category"
    t.string   "code"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "account_id"
    t.integer  "address_id"
    t.boolean  "active"
    t.string   "database_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "title"
    t.boolean  "suppress_account_name"
    t.boolean  "suppress_contact_name"
  end

  create_table "contacts_invoices", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.integer "invoice_id"
  end

  create_table "email_records", :force => true do |t|
    t.integer  "account_id"
    t.integer  "invoice_id"
    t.string   "email"
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "cc"
    t.string   "bcc"
  end

  create_table "email_templates", :force => true do |t|
    t.string   "subject"
    t.text     "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.date     "date"
    t.integer  "primary_contact_id"
    t.string   "ar_account"
    t.boolean  "void",               :default => false
    t.decimal  "balance_due"
    t.date     "last_email"
    t.decimal  "total"
  end

  create_table "items", :force => true do |t|
    t.text     "description"
    t.string   "revenue_gl_code"
    t.decimal  "quantity"
    t.decimal  "unit_price"
    t.string   "item_image_url"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "notes"
    t.boolean  "recurring"
    t.string   "expensify_id"
    t.integer  "invoice_id"
    t.integer  "account_id"
    t.integer  "line_id"
  end

  create_table "lines", :force => true do |t|
    t.text     "description"
    t.integer  "item_id"
    t.decimal  "quantity"
    t.decimal  "unit_price"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "invoice_id"
    t.boolean  "hidden"
    t.string   "notes"
    t.integer  "position"
    t.decimal  "total"
  end

  create_table "payments", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "account_id"
    t.date     "payment_date"
    t.string   "payment_type"
    t.string   "reference_number"
    t.decimal  "amount"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.text     "category"
    t.text     "value"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "settings", ["key"], :name => "index_settings_on_key", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "notify_on_all_actions", :default => false
  end

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "versions", :force => true do |t|
    t.string   "item_type",      :null => false
    t.integer  "item_id",        :null => false
    t.string   "event",          :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end

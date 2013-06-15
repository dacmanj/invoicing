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

ActiveRecord::Schema.define(:version => 20130615152647) do

  create_table "addresses", :force => true do |t|
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "address_line_3"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "phone"
    t.string   "fax"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "contact_id"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "default_account_ar_account"
    t.integer  "contact_id"
    t.integer  "address_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "database_id"
  end

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "company_id"
    t.integer  "address_id"
    t.boolean  "active"
    t.string   "database_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "contacts_invoices", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.integer "invoice_id"
  end

  create_table "invoices", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "company_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "description"
    t.string   "revenue_gl_code"
    t.string   "receivable_gl_code"
    t.decimal  "quantity"
    t.decimal  "unit_price"
    t.string   "item_image_url"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "lines", :force => true do |t|
    t.string   "description"
    t.integer  "item_id"
    t.decimal  "quantity"
    t.decimal  "unit_price"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "invoice_id"
  end

  create_table "payments", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "company_id"
    t.date     "payment_date"
    t.string   "payment_type"
    t.string   "reference_number"
    t.decimal  "amount"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end

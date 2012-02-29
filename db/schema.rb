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

ActiveRecord::Schema.define(:version => 20120229071112) do

  create_table "articles", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.boolean  "enabled"
    t.text     "content"
    t.string   "page"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cart_items", :force => true do |t|
    t.integer  "cart_id"
    t.integer  "product_id"
    t.text     "specifications"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carts", :force => true do |t|
    t.string   "cookie"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "categories", ["parent_category_id"], :name => "index_categories_on_parent_category_id"
  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.string   "title",            :default => ""
    t.text     "body"
    t.string   "subject",          :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "order_addresses", :force => true do |t|
    t.integer  "order_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "street_1"
    t.string   "street_2"
    t.string   "state"
    t.string   "city"
    t.string   "country"
    t.string   "postal_code"
    t.string   "address_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_addresses", ["country"], :name => "index_order_addresses_on_country"
  add_index "order_addresses", ["order_id"], :name => "index_order_addresses_on_order_id"

  create_table "order_contents", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_item_details", :force => true do |t|
    t.integer  "order_item_id"
    t.integer  "product_option_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_item_details", ["order_item_id"], :name => "index_order_item_details_on_order_item_id"
  add_index "order_item_details", ["product_option_id"], :name => "index_order_item_details_on_product_option_id"

  create_table "order_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.float    "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_option_id"
  end

  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"
  add_index "order_items", ["product_id"], :name => "index_order_items_on_product_id"

  create_table "orders", :force => true do |t|
    t.integer  "seller_id"
    t.integer  "payment_type_id"
    t.boolean  "different_address"
    t.float    "total_price"
    t.string   "email"
    t.string   "ip_address"
    t.string   "payment_method_name"
    t.string   "payment_state"
    t.string   "state"
    t.string   "reference_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shipping_method_id"
  end

  add_index "orders", ["id", "reference_number"], :name => "index_orders_on_id_and_transaction_reference_id", :unique => true
  add_index "orders", ["payment_method_name"], :name => "index_orders_on_payment_method_name"
  add_index "orders", ["payment_type_id"], :name => "index_orders_on_payment_type_id"
  add_index "orders", ["seller_id"], :name => "index_orders_on_seller_id"

  create_table "payment_types", :force => true do |t|
    t.boolean  "activated"
    t.string   "name"
    t.string   "description"
    t.string   "requisite_merchant_account"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_images", :force => true do |t|
    t.integer  "product_id"
    t.integer  "image_file_size"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_images", ["product_id"], :name => "index_product_images_on_product_id"

  create_table "product_options", :force => true do |t|
    t.integer  "product_id"
    t.string   "description"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ordered_quantity", :default => 0
    t.float    "additional_cost"
  end

  add_index "product_options", ["product_id"], :name => "index_product_options_on_product_id"

  create_table "product_payment_options", :force => true do |t|
    t.integer  "product_id"
    t.integer  "payment_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_shipping_options", :force => true do |t|
    t.integer  "product_id"
    t.integer  "shipping_option_id"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_widget_contents", :force => true do |t|
    t.integer  "product_widget_id"
    t.integer  "product_option_id"
    t.string   "name"
    t.string   "input_type"
    t.text     "css_style"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_widget_contents", ["product_widget_id"], :name => "index_product_widget_contents_on_product_widget_id"

  create_table "product_widgets", :force => true do |t|
    t.integer  "product_id"
    t.boolean  "embedded"
    t.boolean  "use_iframe"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_widgets", ["product_id"], :name => "index_product_widgets_on_product_id"

  create_table "products", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "on_discount"
    t.float    "price"
    t.float    "discounted_price"
    t.float    "rating",            :default => 0.0
    t.float    "views",             :default => 0.0
    t.integer  "category_id"
    t.string   "name"
    t.string   "slug"
    t.string   "code"
    t.string   "state"
    t.text     "description"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ordered_quantity",  :default => 0
    t.boolean  "customized_widget"
    t.string   "post_url"
  end

  add_index "products", ["category_id"], :name => "index_products_on_category_id"
  add_index "products", ["code"], :name => "index_products_on_code", :unique => true
  add_index "products", ["id"], :name => "index_products_on_id", :unique => true
  add_index "products", ["slug"], :name => "index_products_on_slug", :unique => true
  add_index "products", ["user_id"], :name => "index_products_on_user_id"

  create_table "project_configs", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_configs", ["key"], :name => "index_project_configs_on_key"

  create_table "shipping_options", :force => true do |t|
    t.float    "cost"
    t.string   "name"
    t.boolean  "activated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "user_merchant_accounts", :force => true do |t|
    t.string   "login"
    t.string   "signature"
    t.string   "password"
    t.string   "email"
    t.string   "merchant_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_merchant_accounts", ["user_id", "merchant_type"], :name => "index_user_merchant_accounts_on_user_id_and_merchant_type"

  create_table "user_payment_methods", :force => true do |t|
    t.integer  "user_id"
    t.integer  "payment_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_payment_methods", ["user_id", "payment_type_id"], :name => "index_user_payment_methods_on_user_id_and_payment_type_id"

  create_table "user_shipping_methods", :force => true do |t|
    t.integer  "user_id"
    t.integer  "shipping_option_id"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_shipping_methods", ["shipping_option_id"], :name => "index_user_shipping_methods_on_shipping_option_id"
  add_index "user_shipping_methods", ["user_id"], :name => "index_user_shipping_methods_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_admin"
    t.float    "rating"
    t.string   "username"
    t.string   "blog_url"
    t.string   "provider"
    t.string   "uid"
    t.text     "auth"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end

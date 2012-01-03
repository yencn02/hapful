class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.belongs_to :user
      t.boolean :on_discount
      t.float :price
      t.float :discounted_price
      t.float :rating, :default=>0
      t.float :views, :default=>0
      t.references :category
      t.string :name
      t.string :slug
      t.string :code
      t.string :state
      t.text :description
      t.integer :quantity
      t.timestamps
    end

    add_index :products, :user_id
    add_index :products, :category_id
    add_index :products, :code, :unique=>true
    add_index :products, :slug, :unique=>true
    add_index :products, :id, :unique=>true
  end

  def self.down
    drop_table :products
  end
end

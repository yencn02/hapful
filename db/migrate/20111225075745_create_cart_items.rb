class CreateCartItems < ActiveRecord::Migration
  def self.up
    create_table :cart_items do |t|
      t.belongs_to :cart
      t.belongs_to :product
      t.text :specifications
      t.timestamps
    end
  end

  def self.down
    drop_table :cart_items
  end
end

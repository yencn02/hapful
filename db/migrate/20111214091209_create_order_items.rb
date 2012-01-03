class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.belongs_to :order
      t.references :product
      t.float :quantity
      t.timestamps
    end

    add_index :order_items, :order_id
    add_index :order_items, :product_id
  end

  def self.down
    drop_table :order_items
  end
end

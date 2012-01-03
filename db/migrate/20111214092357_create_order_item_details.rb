class CreateOrderItemDetails < ActiveRecord::Migration
  def self.up
    create_table :order_item_details do |t|
      t.belongs_to :order_item
      t.references :product_option
      t.timestamps
    end

    add_index :order_item_details, :order_item_id
    add_index :order_item_details, :product_option_id
  end

  def self.down
    drop_table :order_item_details
  end
end

class AddProductOptionIdToOrderItem < ActiveRecord::Migration
  def self.up
    add_column :order_items, :product_option_id, :integer
  end

  def self.down
    remove_column :order_items, :product_option_id
  end
end

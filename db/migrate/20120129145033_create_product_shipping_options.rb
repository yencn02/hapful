class CreateProductShippingOptions < ActiveRecord::Migration
  def self.up
    create_table :product_shipping_options do |t|
      t.belongs_to :product
      t.belongs_to :shipping_option
      t.float :amount
      t.timestamps
    end
  end

  def self.down
    drop_table :product_shipping_options
  end
end

class CreateOrderContents < ActiveRecord::Migration
  def self.up
    create_table :order_contents do |t|
      t.belongs_to :order
      t.belongs_to :product
      t.integer :quantity
      t.float :price
      t.timestamps
    end
  end

  def self.down
    drop_table :order_contents
  end
end

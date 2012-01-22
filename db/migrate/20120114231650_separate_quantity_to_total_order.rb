class SeparateQuantityToTotalOrder < ActiveRecord::Migration
  def self.up
    add_column :products, :ordered_quantity, :integer, :default=>0
    add_column :product_options, :ordered_quantity, :integer, :default=>0
  end

  def self.down
    remove_column :products, :ordered_quantity
    remove_column :product_options, :ordered_quantity
  end
end

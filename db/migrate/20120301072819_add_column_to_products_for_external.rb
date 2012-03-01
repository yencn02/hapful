class AddColumnToProductsForExternal < ActiveRecord::Migration
  def self.up
    add_column :products, :use_hapful, :boolean
  end

  def self.down
    remove_column :products, :use_hapful
  end
end

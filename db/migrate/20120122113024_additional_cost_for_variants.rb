class AdditionalCostForVariants < ActiveRecord::Migration
  def self.up
    add_column :product_options, :additional_cost, :float
  end

  def self.down
    remove_column :product_options, :additional_cost
  end
end

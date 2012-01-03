class CreateProductOptions < ActiveRecord::Migration
  def self.up
    create_table :product_options do |t|
      t.belongs_to :product
      t.string :description
      t.integer :quantity
      t.timestamps
    end

    add_index :product_options, [:product_id]
  end

  def self.down
    drop_table :product_options
  end
end

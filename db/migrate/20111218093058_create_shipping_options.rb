class CreateShippingOptions < ActiveRecord::Migration
  def self.up
    create_table :shipping_options do |t|
      t.float :cost
      t.string :name
      t.boolean :activated
      t.timestamps
    end
  end

  def self.down
    drop_table :shipping_options
  end
end

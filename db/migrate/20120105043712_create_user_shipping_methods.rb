class CreateUserShippingMethods < ActiveRecord::Migration
  def self.up
    create_table :user_shipping_methods do |t|
      t.belongs_to :user
      t.belongs_to :shipping_option
      t.float :amount
      t.timestamps
    end

    add_index :user_shipping_methods, [:user_id]
    add_index :user_shipping_methods, [:shipping_option_id]
  end

  def self.down
    drop_table :user_shipping_methods
  end
end

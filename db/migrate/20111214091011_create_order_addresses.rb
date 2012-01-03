class CreateOrderAddresses < ActiveRecord::Migration
  def self.up
    create_table :order_addresses do |t|
      t.belongs_to :order
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :street_1
      t.string :street_2
      t.string :state
      t.string :city
      t.string :country
      t.string :postal_code
      t.string :address_type
      t.timestamps
    end

    add_index :order_addresses, :order_id
    add_index :order_addresses, :country
  end

  def self.down
    drop_table :order_addresses
  end
end

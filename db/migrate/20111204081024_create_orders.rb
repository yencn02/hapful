class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders, :force=>true do |t|
      t.belongs_to :seller
      t.belongs_to :payment_type
      t.boolean :different_address
      t.float :total_price
      t.string :email
      t.string :ip_address
      t.string :payment_method_name
      t.string :payment_state
      t.string :state
      t.string :transaction_reference_id
      t.timestamps
    end
    add_index :orders, [:id, :transaction_reference_id], :unique=>true
    add_index :orders, :seller_id
    add_index :orders, :payment_method_name
    add_index :orders, :payment_type_id

  end

  def self.down
    drop_table :orders
  end
end

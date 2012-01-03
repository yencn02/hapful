class CreateUserPaymentMethods < ActiveRecord::Migration
  def self.up
    create_table :user_payment_methods do |t|
      t.belongs_to :user
      t.belongs_to :payment_type
      t.timestamps
    end
    add_index :user_payment_methods, [:user_id, :payment_type_id]
  end

  def self.down
    drop_table :user_payment_methods
  end
end

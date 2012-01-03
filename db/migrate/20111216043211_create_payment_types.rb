class CreatePaymentTypes < ActiveRecord::Migration
  def self.up
    create_table :payment_types do |t|
      t.boolean :activated
      t.string :name
      t.string :description
      t.string :requisite_merchant_account
      t.timestamps
    end
  end

  def self.down
    drop_table :payment_types
  end
end

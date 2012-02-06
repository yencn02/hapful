class CreateProductPaymentOptions < ActiveRecord::Migration
  def self.up
    create_table :product_payment_options do |t|
      t.belongs_to :product
      t.belongs_to :payment_type
      t.timestamps
    end
  end

  def self.down
    drop_table :product_payment_options
  end
end

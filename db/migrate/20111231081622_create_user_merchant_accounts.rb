class CreateUserMerchantAccounts < ActiveRecord::Migration
  def self.up
    create_table :user_merchant_accounts do |t|
      t.string :login
      t.string :signature
      t.string :password
      t.string :email
      t.string :merchant_type
      t.belongs_to :user
      t.timestamps
    end
    add_index :user_merchant_accounts, [:user_id, :merchant_type]
  end

  def self.down
    drop_table :user_merchant_accounts
  end
end

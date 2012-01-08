class RenameTransactionReferenceId < ActiveRecord::Migration
  def self.up
    rename_column :orders, :transaction_reference_id, :reference_number
  end

  def self.down
    rename_column :orders, :reference_number, :transaction_reference_id
  end
end

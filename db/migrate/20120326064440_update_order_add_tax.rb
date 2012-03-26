class UpdateOrderAddTax < ActiveRecord::Migration
  def self.up
    add_column :orders, :tax, :float
    create_table :taxes do |t|
      t.integer   :user_id
      t.string   :state
      t.float     :percentage
    end
  end

  def self.down
    remove_column :orders, :tax
    drop_table :taxes
  end
end

class AddedColumnForUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :is_admin, :boolean
    add_column :users, :rating, :float
    add_column :users, :username, :string
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :is_admin
    remove_column :users, :rating
  end
end

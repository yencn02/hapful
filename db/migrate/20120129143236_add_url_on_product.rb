class AddUrlOnProduct < ActiveRecord::Migration
  def self.up
    add_column :users, :blog_url, :string
    add_column :products, :post_url, :string
  end

  def self.down
    remove_column :users, :blog_url
    remove_column :products, :post_url
  end
end

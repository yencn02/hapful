class AddSlugToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :slug, :string
    add_index :categories, :slug, :unique=>true
    Category.find_each(&:save)
  end

  def self.down
    remove_column :categories, :slug
  end
end

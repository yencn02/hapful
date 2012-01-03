class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.references :parent_category
      t.timestamps
    end
    add_index :categories, [:parent_category_id]
  end

  def self.down
    drop_table :categories
  end
end

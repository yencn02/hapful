class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :name
      t.string :slug
      t.boolean :enabled
      t.text :content
      t.string :page
      t.integer :priority
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end

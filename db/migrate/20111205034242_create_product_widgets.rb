class CreateProductWidgets < ActiveRecord::Migration
  def self.up
    create_table :product_widgets do |t|
      t.belongs_to :product
      t.boolean :embedded
      t.boolean :use_iframe
      t.string :title
      t.text :content
      t.timestamps
    end

    add_index :product_widgets, [:product_id], :unique => true
  end

  def self.down
    drop_table :product_widgets
  end
end

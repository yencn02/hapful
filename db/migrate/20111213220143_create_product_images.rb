class CreateProductImages < ActiveRecord::Migration
  def self.up
    create_table :product_images do |t|
      t.belongs_to :product
      t.integer :image_file_size
      t.string :image_file_name
      t.string :image_content_type
      t.timestamps
    end
    add_index :product_images, [:product_id]
  end

  def self.down
    drop_table :product_images
  end
end

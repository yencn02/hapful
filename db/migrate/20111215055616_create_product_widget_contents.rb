class CreateProductWidgetContents < ActiveRecord::Migration
  def self.up
    create_table :product_widget_contents do |t|
      t.belongs_to :product_widget
      t.belongs_to :product_option
      t.string :name
      t.string :input_type
      t.text :css_style
      t.timestamps
    end
    add_index :product_widget_contents, :product_widget_id
  end

  def self.down
    drop_table :product_widget_contents
  end
end

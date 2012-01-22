class AddDefaultBooleanOnProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :customized_widget, :boolean
  end

  def self.down
    remove_column :products, :customized_widget
  end
end

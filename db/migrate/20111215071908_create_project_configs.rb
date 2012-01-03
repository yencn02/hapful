class CreateProjectConfigs < ActiveRecord::Migration
  def self.up
    create_table :project_configs do |t|
      t.string :key
      t.string :value
      t.string :description
      t.timestamps
    end
    add_index :project_configs, :key
  end

  def self.down
    drop_table :project_configs
  end
end

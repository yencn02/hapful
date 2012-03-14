class CreateCustomEmails < ActiveRecord::Migration
  def self.up
    create_table :custom_emails do |t|
      t.string :identifier
      t.text :template
      t.string :content_type
      t.string :subject
      t.timestamps
    end
  end

  def self.down
    drop_table :custom_emails
  end
end

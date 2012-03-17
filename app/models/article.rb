class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  PAGES = [:main, :help, :faqs, :terms, :privacy_policy]

  scope :enabled, where({:enabled=>true})
  scope :welcome, where({:page=>'main'})

  validates :name, :presence=>true, :uniqueness=>true
  validates :content, :presence=>true


  def enable
    self.enabled = true
    save
  end

  def self.index_page
    find(:first, :conditions=>{:enabled=>true, :page=>'main'})
  end

end

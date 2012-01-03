class Category < ActiveRecord::Base

  validates :name, :presence=>true, :uniqueness=>true

  belongs_to :parent_category, :class_name=>'Category', :foreign_key=>'parent_category_id'

  has_many :children, :class_name=>'Category', :foreign_key=>'parent_category_id'
  has_many :products

  #used roots instead of parents or ancestors since both are used by rails
  scope :roots, where({:parent_category_id=>nil})
  
end

class ProductWidget < ActiveRecord::Base

  belongs_to :product

  has_many :contents, :class_name=>'ProductWidgetContent', :dependent=>:destroy

  accepts_nested_attributes_for :contents
  
end

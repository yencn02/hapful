class ProductOption < ActiveRecord::Base

  belongs_to :product

  has_one :widget_style, :class_name=>"ProductWidgetContent"

  validates :description, :presence=>true
  validates :quantity, :presence=>true
  
  private

end
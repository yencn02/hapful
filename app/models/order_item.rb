class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :product_option

  delegate :value, :to=>:product_option, :allow_nil=>true, :prefix=>true
end

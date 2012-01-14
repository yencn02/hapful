class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :product_option

  delegate :description, :to=>:product_option, :allow_nil=>true, :prefix=>false
  delegate :name, :to=>:product, :allow_nil=>true, :prefix=>false

  def calculated_price
    product.effective_price.to_f * quantity.to_f
  end
end

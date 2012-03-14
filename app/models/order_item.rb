class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :product_option

  delegate :description, :to=>:product_option, :allow_nil=>true, :prefix=>false
  delegate :name, :to=>:product, :allow_nil=>true, :prefix=>false
  delegate :additional_cost, :to=>:product_option, :allow_nil=>true, :prefix=>false

  def calculated_price
    calc_amount = product.effective_price.to_f
    calc_amount += product_option.additional_cost.to_f unless product_option.nil?
    calc_amount * quantity.to_f
  end
end

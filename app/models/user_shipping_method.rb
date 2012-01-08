class UserShippingMethod < ActiveRecord::Base

  belongs_to :user
  belongs_to :shipping_option

  delegate :name, :to=>:shipping_option, :allow_nil=>true, :prefix=>false
  
  def is_free?
    amount.to_f == 0.0
  end

  def humanized_amount
    is_free? ? 'FREE' : amount
  end
  
end

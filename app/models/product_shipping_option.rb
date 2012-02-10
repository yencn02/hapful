class ProductShippingOption < ActiveRecord::Base

  belongs_to :product
  belongs_to :shipping_option

  delegate :name, :to=>:shipping_option, :prefix=>false, :allow_nil=>true

  before_create :init_amount

  def is_free?
    amount.to_f == 0.0
  end

  def humanized_amount
    is_free? ? 'FREE' : amount
  end

  def init_amount
    self.amount = amount.to_f
  end

  
end


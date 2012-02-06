class ProductPaymentOption < ActiveRecord::Base

  belongs_to :product
  belongs_to :payment_type

  delegate :name, :to=>:payment_type, :prefix=>false, :allow_nil=>true

end

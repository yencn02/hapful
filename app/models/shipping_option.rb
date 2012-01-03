class ShippingOption < ActiveRecord::Base

  validates :name, :presence=>true, :uniqueness=>true

  scope :active, where(:activated=>true)
  
end

class ShippingOption < ActiveRecord::Base

  validates :name, :presence=>true, :uniqueness=>true

  scope :active, where(:activated=>true)

  DEFAULT_VALUES = ['UPS', 'US Postal Service', 'Meet-up']
  
end

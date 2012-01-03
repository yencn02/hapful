class UserPaymentMethod < ActiveRecord::Base

  belongs_to :user
  belongs_to :payment_type
  
end

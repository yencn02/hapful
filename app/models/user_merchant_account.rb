class UserMerchantAccount < ActiveRecord::Base

  TYPES = {
    #    :google=>"Google Checkout Account",
    :paypal=>"Paypal Account"
  }
  
  belongs_to :user


end

class UserMerchantAccount < ActiveRecord::Base

  TYPES = {
    #    :google=>"Google Checkout Account",
    :paypal=>"Paypal Express"
  }
  
  belongs_to :user

  validates_uniqueness_of :merchant_type, :scope=>:user_id

end

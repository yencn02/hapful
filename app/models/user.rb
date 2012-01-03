class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :username

  has_many :products, :dependent=>:destroy
  has_many :orders, :foreign_key=>'seller_id'
  has_many :merchant_accounts,  :class_name=>'UserMerchantAccount',:dependent=>:destroy
  has_many :payment_methods,    :class_name=>'UserPaymentMethod'
  has_many :payment_types,    :through=>:payment_methods, :source=>:payment_type

  validates :username, :presence=>true, :uniqueness=>true


  def make_admin!
    self.is_admin = true
    save
  end

  def cant_use_payment_type(payment_type)
    payment_type.requisite_merchant_account.blank? ? false : merch_account_for_payment_type(payment_type).nil?
  end

  def merch_account_for_payment_type(payment_type)
    merchant_accounts.find(:first, :conditions=>{:merchant_type=>payment_type.requisite_merchant_account})
  end
  
end

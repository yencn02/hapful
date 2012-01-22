class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :username

  has_many :products, :dependent=>:destroy
  has_many :orders, :foreign_key=>'seller_id'
  has_many :merchant_accounts,  :class_name=>'UserMerchantAccount',:dependent=>:destroy do
    def for_type(type)
      find(:first, :conditions=>{:merchant_type=>type})
    end
  end
  has_many :payment_methods,    :class_name=>'UserPaymentMethod', :dependent=>:destroy
  has_many :payment_types,    :through=>:payment_methods, :source=>:payment_type
  has_many :shipping_methods, :class_name=>'UserShippingMethod', :order=>"amount", :dependent=>:destroy do
    def for_option(option)
      find(:first, :conditions=>{:shipping_option_id=>option.id}) || UserShippingMethod.new
    end
  end
  has_many :shipping_options, :through=>:shipping_methods, :source=>:shipping_option
  validates :username, :presence=>true, :uniqueness=>true

  accepts_nested_attributes_for :merchant_accounts, :allow_destroy=>true
  accepts_nested_attributes_for :payment_methods, :allow_destroy=>true
  accepts_nested_attributes_for :shipping_methods, :allow_destroy=>true


  def make_admin!
    self.is_admin = true
    save
  end

  def cant_use_payment_type(payment_type)
    payment_type.requisite_merchant_account.blank? ? false : merch_account_for_payment_type(payment_type).nil?
  end

  def incomplete_merchant_details?
    merchant_accounts.empty? || shipping_methods.empty? || payment_methods.empty?
  end

  def merch_account_for_payment_type(payment_type)
    merchant_accounts.find(:first, :conditions=>{:merchant_type=>payment_type.requisite_merchant_account})
  end
  
end

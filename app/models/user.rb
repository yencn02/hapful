class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable
  acts_as_voter

  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  
  ## CALLBACKS

  after_create :send_welcome_email


  ## AASM 'look-alike' methods
  STATES = %w(banned active)
  STATES.each do |state|
    define_method "#{state}?" do
      self.state == state
    end
    define_method "#{state}!" do
      self.state = state
      self.save(false)
    end
  end



  has_many :products, :class_name=>'Product', :conditions=>["use_hapful=?", true], :dependent=>:destroy
  has_many :posts, :class_name=>'Product', :conditions=>["use_hapful=?", false], :dependent=>:destroy

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

  def send_welcome_email
    UserMailer.welcome_email(self).deliver if self.provider.blank?
  end

  def name=(fullname)
    self.first_name = fullname.to_s.split(" ").first.to_s
    self.last_name = fullname.to_s.gsub(self.first_name, "").strip
  end

  def self.create_with_omniauth(auth)
    data = auth.extra.raw_info
    case auth["provider"]
    when "twitter"
      user = User.new
      user.username = data.screen_name
      user.name = data.name
      user.email = "#{user.username}@hapful.com"
    when "facebook"
      user = User.find_by_email(data.email)
      unless user
        user = User.new
        user.name = data.name
        user.username = data.name.to_s.downcase.gsub(" ", "-")
        user.email = data.email
      end
    end
    user.provider = auth["provider"]
    user.uid = auth["uid"]
    user.save(:validate => false)
    return user
  end

  def auth
    begin
      JSON.parse(self[:auth])
    rescue
      self[:auth]
    end
  end

  
  
end

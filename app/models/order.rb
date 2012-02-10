class Order < ActiveRecord::Base

  after_initialize :initalize_billing_address, :set_states
  after_create :send_new_order_email_to_seller
  
  belongs_to :seller, :class_name=>"User", :foreign_key=>'seller_id'
  belongs_to :payment_type
  belongs_to :shipping_method, :foreign_key=>'shipping_method_id', :class_name=>'ProductShippingOption'

  before_save :save_total_amount
  before_create :set_product_quantities
  
  has_many :items, :class_name=>"OrderItem", :dependent=>:destroy
  has_many :products, :through=>:items
  
  has_one :billing_address, :class_name=>"OrderAddress", :conditions=>{:address_type=>"billing"}, :dependent=>:destroy
  has_one :shipping_address, :class_name=>"OrderAddress", :conditions=>{:address_type=>"shipping"}, :dependent=>:destroy

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address, :reject_if=>proc{|attr| attr['diff_add'].eql?('false')}

  validate :check_shipping_method
  validates :email, :presence=>true

  scope :recent, :order=>'created_at', :limit=>10

  STATES = %w(new for_delivery complete canceled canceled_by_seller)
  STATES.each do |state|
    define_method "mark_as_#{state}!" do
      self.state = state
      save!
    end
  end


  PAYMENT_STATES =  %w(paid pending)
  PAYMENT_STATES.each do |state|
    define_method "mark_payment_state_as_#{state}!" do
      self.payment_state = state
      save!
    end
  end

  ## Section 1: Item related codes ##
  def initialize_items(cart)
    cart.each do |cart_content|
      self.items.build(
        :product_id=>cart_content[:product_id],
        :quantity=>cart_content[:quantity],
        :product_option_id=>cart_content[:product_option_id]
      )
    end
  end
  
  def set_product_quantities
    items.each do |item|
      deductable_object = item.product_option_id.nil? ? item.product : item.product_option
      deductable_object.ordered_quantity += item.quantity
      deductable_object.save(false)
    end
  end

  def shipping_method_name
    shipping_method.shipping_option.name
  end

  def total_amount
    (subtotal_amount + shipping_amount + tax_amount + handling_amount).to_f
  end

  def arrayed_items(cents = false)
    arr = []
    items.each do |item|
      calc_amount = item.product.effective_price + item.additional_cost.to_f
      arr << {
        :name     => item.name,
        :number   => item.product.code,
        :quantity => item.quantity.to_i,
        :amount   => cents ? calc_amount.to_cents : calc_amount
      }
    end
    arr
  end

  def subtotal_amount
    amount = 0.0
    items.each do |item|
      amount += item.calculated_price
    end
    amount
  end

  def shipping_amount
    shipping_method.amount.to_f
  end

  def tax_amount
    0.0
  end

  def handling_amount
    0.0
  end

  def payment_via_paypal_express?
    payment_method_name == 'Paypal Express'
  end

  def build_reference(string)
    self.reference_number = Time.now.to_i + id
  end

  def available_shipping_options_for(cart)
    cart.collect{|a| a[:product]}.collect{|a| a.shipping_options}.flatten.sort{|a,b| a.amount<=>b.amount}.uniq
  end

  def accepted_payment_types
    products.collect(&:payment_types).flatten.uniq
  end

  private
  def set_states
    self.state ||= 'new'
    self.payment_state ||= 'pending'
  end

  def check_shipping_method
    if self.shipping_method_id.nil?
      self.errors.add_to_base("Please select a shipping method")
    end
  end

  def initalize_billing_address
    self.build_billing_address unless billing_address
  end

  def save_total_amount
    self.total_price = total_amount
  end

  def send_new_order_email_to_seller
    OrderMailer.new_order_email(self).deliver
  end
  
end

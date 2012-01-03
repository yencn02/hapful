class Order < ActiveRecord::Base

  after_initialize :initalize_billing_address, :set_states
  
  belongs_to :seller, :class_name=>"User", :foreign_key=>'seller_id'
  belongs_to :payment_type

  before_save :save_total_amount
  
  has_many :items, :class_name=>"OrderItem", :dependent=>:destroy
  
  has_one :billing_address, :class_name=>"OrderAddress", :conditions=>{:address_type=>"billing"}, :dependent=>:destroy
  has_one :shipping_address, :class_name=>"OrderAddress", :conditions=>{:address_type=>"shipping"}, :dependent=>:destroy

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address, :reject_if=>proc{|attr| attr['diff_add'].eql?('false')}

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
  
  def initialize_items(cart)
    cart.each do |cart_content|
      self.items.build(:product_id=>cart_content[:product_id], :quantity=>cart_content[:quantity] )
    end
  end

  def total_amount
    (subtotal_amount + shipping_amount + tax_amount).to_f
  end

  def arrayed_items
    arr = []
    items.each do |item|
      arr << {
        :name     => item.product.name,
        :number   => item.product.code,
        :quantity => item.quantity.to_i,
        :amount   => item.product.effective_price.to_cents
      }
    end
    arr
  end

  def subtotal_amount
    amount = 0.0
    items.each do |item|
      amount += ( item.product.effective_price * item.quantity.to_i)
    end
    amount
  end

  def shipping_amount
    0.0
  end

  def tax_amount
    0.0
  end

  def payment_via_paypal_express?
    payment_method_name == 'Paypal Express'
  end

  private
  def set_states
    self.state = 'new'
    self.payment_state = 'pending'
  end

  def initalize_billing_address
    self.build_billing_address unless billing_address
  end

  def save_total_amount
    self.total_price = total_amount
  end
  
end

class OrdersController < ApplicationController

  before_filter :authenticate_user!, :only=>[:index, :change_state]
  before_filter :initialize_cart_and_seller, :only=>[:new, :create]
  
  def index
    @orders = current_user.orders
  end

  def new
    if @cart.empty?
      return redirect_to '/my-cart'
    end
    @order = Order.new()
    @order.seller = @seller
    @order.build_shipping_address
  end

  def create
    @order = Order.new(params[:order].merge!(:ip_address=>request.remote_ip))
    @order.seller = @seller
    @order.initialize_items(@cart_for_seller) if @order.items.blank?
    if @order.save
      session[:active_order]=@order.id
      redirect_to payment_checkout_path
    else
      @order.build_shipping_address unless @order.shipping_address
      render 'new'
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  def cancel
  end

  def verify_for_show
  end

  def completed
    return redirect_to market_path if session[:active_order].nil?
    @order = Order.find(session[:active_order])
    OrderMailer.order_complete_for_buyer(@order).deliver if @order.mark_as_for_delivery!
    session[:active_order] = nil
  end

  def change_state
    @order = Order.find(params[:id])
    if Order::STATES.include?(params[:state])
      if @order.send("mark_as_#{params[:state]}!".to_sym)
        redirect_to [@order], :notice=>"Order state successfully changed."
      end
    end
  end

  private

  def initialize_cart_and_seller
    build_objects_from_cookies
    @seller = User.find_by_username(params[:merchant])
    @cart_for_seller = @cart[@seller]
  end
end

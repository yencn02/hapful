class PaymentsController < ApplicationController

  def new
    @order = Order.find(session[:active_order])
  end
  
  def create
    payment_type=PaymentType.find_by_name(params[:payment][:method])
    @order = Order.find(session[:active_order])
    @order.update_attributes({:payment_method_name=>payment_type.name, :payment_type_id=>payment_type.id})
    target_url = if @order.payment_via_paypal_express?
      paypal_express_checkout_url
    else
      set_payment_state_url('pending')
    end
    redirect_to target_url
  end

  def paypal_express
    @order = Order.find(session[:active_order])
    initialize_paypal_credentials
    if @order
      begin
        @gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(@paypal_credentials)
        paypal_response = @gateway.setup_purchase(@order.total_amount.to_cents,
          :ip                => request.remote_ip,
          :return_url        => complete_paypal_express_url,
          :cancel_return_url => show_cart_url,
          :items             => @order.arrayed_items,
          :subtotal          => @order.subtotal_amount.to_cents,
          :shipping          => @order.shipping_amount.to_cents,
          :tax               => @order.tax_amount.to_cents
        )
        @order.transaction_reference_id = paypal_response.token
        @order.save
        redirect_to @gateway.redirect_url_for(paypal_response.token)
      rescue Exception => e
        redirect_to show_cart_path, :notice=>"Please try again"
      end
    else
      redirect_to show_cart_path, :notice=>"Please checkout your cart."
    end
  end

  def complete_paypal_express
    @order = Order.find(session[:active_order])
    initialize_paypal_credentials
    @gateway = ActiveMerchant::Billing::PaypalExpressGateway.new(@paypal_credentials)
    purchase = @gateway.purchase(@order.total_amount.to_cents,
      :ip                => request.remote_ip,
      :payer_id          => params[:PayerID],
      :token             => params[:token],
      :return_url        => complete_paypal_express_url,
      :cancel_return_url => show_cart_url,
      :items             => @order.arrayed_items,
      :subtotal          => @order.subtotal_amount.to_cents,
      :shipping          => @order.shipping_amount.to_cents,
      :tax               => @order.tax_amount.to_cents
    )
    if purchase.success?
      redirect_to set_payment_state_url('paid')
    else
      render :text=>purchase.message
    end
  end

  def set_state
    @order = Order.find(session[:active_order])
    if Order::PAYMENT_STATES.include?(params[:state])
      clear_cart_cookies
      @order.mark_payment_state_as_paid!
      redirect_to completed_order_path
    end
  end

  private

  def initialize_paypal_credentials
    @paypal_credentials = {
      :login=>ProjectConfig.value('paypal_login'),
      :password=>ProjectConfig.value('paypal_password'),
      :signature=>ProjectConfig.value('paypal_signature'),
      :subject=>@order.seller.merch_account_for_payment_type(@order.payment_type).email
    }
  end

  def clear_cart_cookies
    cookies["#{cookies["_hapful_session"]}-#{@order.seller_id}".to_sym] = nil
    cart_sellers = Marshal.load(cookies["#{cookies["_hapful_session"]}-sellers".to_sym]) rescue []
    cart_sellers = cart_sellers - [@order.seller_id]
    cookies["#{cookies["_hapful_session"]}-sellers".to_sym] = {
      :value => Marshal.dump(cart_sellers),
      :expires => 4.years.from_now
    }
  end
end

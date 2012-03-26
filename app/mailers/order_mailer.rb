class OrderMailer < LiquidMailTemplate

  def order_complete_for_buyer(order)
    @identifier = :order_complete
    @order = order
    @url  = "#{ProjectConfig.value('site_url')}"
    create_custom_email
    mail(:to => @order.email, :subject => "Order ##{order.reference_number} completed.")
  end

  
  def new_order_email_for_seller(order)
    @identifier = :order_placed
    @order = order
    @url  = "#{ProjectConfig.value('site_url')}"
    create_custom_email
    mail(:to=>order.seller.email, :subject=>"New order has been placed by #{order.email}")
  end

  
  
end

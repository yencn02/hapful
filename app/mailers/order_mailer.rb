class OrderMailer < ActionMailer::Base
  default :from => "#{ProjectConfig.value('email_sender')}"

  def order_complete(order)
    @order = order
    @url  = "#{ProjectConfig.value('site_url')}"
    mail(:to => @order.email, :subject => "Order ##{order.reference_number} completed.")
  end

  def new_order_email(order)
    @order = order
    @url  = "#{ProjectConfig.value('site_url')}"
    mail(:to=>order.seller.email, :subject=>"New order has been placed by #{order.email}")
  end
  
end

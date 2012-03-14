class CustomEmail < ActiveRecord::Base

  IDENTIFIERS = [:welcome_email, :order_complete, :order_placed]

  TEMPLATES = {
    :welcome_email => %Q!Welcome {{ user_email }}!,
    :order_complete => %Q!Order is completed for {{ order_id }}!,
    :order_placed => %Q!Order is placed for {{ order_id }}!
  }

  SUBJECTS = {
    :welcome_email => "Welcome to Hapful.com!",
    :order_complete => "Order is Complete",
    :order_placed => "Order is Placed"
  }
end

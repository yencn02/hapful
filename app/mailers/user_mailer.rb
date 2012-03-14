class UserMailer < ActionMailer::Base

  default :from => "#{ProjectConfig.value('email_sender')}"

  def welcome_email(user)
    @identifier = :welcome_email
    @user = user
    initialize_custom_email
    @content = build_content_from_template if @custom_email
    @url  = "#{ProjectConfig.value('site_url')}"
    mail(:to => user.email, :subject => @subject)
  end

  # seller
  def order_placed(seller)
    @identifier = :order_placed
    initialize_custom_email
    mail(:to => seller.email, :subject => @subject)
  end

  def order_completed(buyer)
    initialize_custom_email
    mail(:to => buyer.email, :subject => @subject)
  end

  # sends mail to buyer
  def order_shipped(buyer)

  end

  #build custom email
  def build_content_from_template
    content_hash = {}
    if @user
      User.column_names.each do |column|
        content_hash["user_#{column}"] = @user.send(column.to_sym)
      end
    end
    if @order
      Order.column_names.each do |column|
        content_hash["order_#{column}"] = @order.send(column.to_sym)
      end
    end
    template = Liquid::Template.parse(@custom_email.template)
    return template.render(content_hash)
  end
  
  private
  
  def initialize_custom_email
    @custom_email = CustomEmail.find_by_identifier(@identifier)
    @subject = @custom_email.subject
  end
  
  
end

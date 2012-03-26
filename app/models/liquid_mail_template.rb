class LiquidMailTemplate < ActionMailer::Base

  default :from => "#{ProjectConfig.value('email_sender')}", 
    :template_path=>'shared/mailer',
    :template_name=>'generic_template'

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

  def create_custom_email
    initialize_custom_email
    @content = build_content_from_template if @custom_email
  end

  def initialize_custom_email
    @custom_email = CustomEmail.find_by_identifier(@identifier)
    @subject = @custom_email.subject
  end
  
end
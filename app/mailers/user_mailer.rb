class UserMailer < LiquidMailTemplate

  def welcome_email(user)
    @identifier = :welcome_email
    @user = user
    @url  = "#{ProjectConfig.value('site_url')}"
    create_custom_email
    mail(:to => user.email, :subject => @subject)
  end
  
end

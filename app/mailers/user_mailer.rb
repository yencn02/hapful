class UserMailer < ActionMailer::Base
  default :from => "#{ProjectConfig.value('email_sender')}"

  def welcome_email(user)
    @user = user
    @url  = "#{ProjectConfig.value('site_url')}"
    mail(:to => user.email, :subject => "Welcome to Hapful.com!")
  end
  
  
end

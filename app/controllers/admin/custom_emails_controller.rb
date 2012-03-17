class Admin::CustomEmailsController < Admin::BaseController

  uses_yui_editor
  
  def index
    CustomEmail::IDENTIFIERS.each do |ident|
      email = CustomEmail.find_or_create_by_identifier(ident, 
        :template=>CustomEmail::TEMPLATES[ident],
        :subject=>CustomEmail::SUBJECTS[ident])
    end
    @custom_emails = CustomEmail.all
  end
  
  def edit
    @custom_email = CustomEmail.find(params[:id])
  end

  def update
    @custom_email = CustomEmail.find(params[:id])
    if @custom_email.update_attributes(params[:custom_email])
      redirect_to [:admin, :custom_emails]
    else
      render :action=>'edit'
    end
  end
  
end
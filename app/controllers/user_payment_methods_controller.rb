class UserPaymentMethodsController < ApplicationController

  before_filter :authenticate_user!
  
  def index
   
  end

  def create
    current_user.payment_type_ids = params[:payment_methods]
    redirect_to [current_user, :user_payment_methods], :notice=>'Payment Methods Enabled'
  end


end

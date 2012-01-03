class UsersController < ApplicationController

  before_filter :authenticate_user!

  def dashboard

  end

  def edit

  end

  def update

  end

  def change_password
    
  end

  def update_password
   @user = current_user
  end

  def manage_paypal_account
    
  end

  def update_paypal_account
    
  end

  
  
  
end

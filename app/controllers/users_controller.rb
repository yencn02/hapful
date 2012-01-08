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

  def merchant_detail
    @user = current_user
    @user.merchant_accounts.build if @user.merchant_accounts.empty?
  end

  def update_merchant_detail
    @user = current_user
    params[:user][:merchant_accounts_attributes].values.each do |values|
      merch = @user.merchant_accounts.for_type(values[:merchant_type]) || @user.merchant_accounts.build
      merch.attributes = values.delete_if{|k,v| k.to_s=='_destroy'}
    end
    
    params[:shipping_method].values.each do |option|
      next if option[:shipping_option_id].blank?
      shipping_method = @user.shipping_methods.find_by_shipping_option_id(option[:shipping_option_id]) || @user.shipping_methods.build
      shipping_method.attributes = option
    end
    @user.payment_type_ids = params[:payment_methods]
    if @user.save
      redirect_to user_dashboard_path, :notice=>'Merchant details was updated.'
    else
      render 'merchant_detail'
    end
  end

  
  
  
end

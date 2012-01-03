class UserMerchantAccountsController < ApplicationController

  before_filter :authenticate_user!
  
  def index
    @merchant_accounts = current_user.merchant_accounts
  end

  def new
    @merchant_account = current_user.merchant_accounts.new
  end

  def create
    @merchant_account = current_user.merchant_accounts.new(params[:user_merchant_account])
    if @merchant_account.save
      redirect_to [current_user, :user_merchant_accounts]
    else
      render 'new'
    end
  end

  def show

  end

  def edit
    @merchant_account = current_user.merchant_accounts.find(params[:id])
  end

  def update
    @merchant_account = current_user.merchant_accounts.find(params[:id])
    if @merchant_account.update_attributes(params[:user_merchant_account])
      redirect_to [current_user, :user_merchant_accounts]
    else
      render 'edit'
    end
  end

  def destroy
    
  end

  
end

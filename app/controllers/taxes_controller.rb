class TaxesController < ApplicationController

  def index
    render :partial => "taxes"
  end

  def create
    tax = current_user.taxes.new(params[:tax])
    tax.save
    flash[:error] = tax.errors.full_messages.first
  end

  def save
    taxes = params[:taxes]
    taxes.keys.each do |id|
      tax = Tax.find(id)
      tax.update_attributes(taxes[id])
    end
    render :action => :create
  end

  def destroy
    tax = Tax.find(params[:id])
    tax.destroy
    render :action => :create
  end
  
end

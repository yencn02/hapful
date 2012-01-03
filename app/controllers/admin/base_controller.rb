class Admin::BaseController < ApplicationController

  layout 'admin'

  before_filter :authenticate_admin


  private

  def user_is_admin?
    !!current_user.is_admin? rescue false
  end

  def authenticate_admin
    unless user_is_admin?
      redirect_to request.referrer, :notice=>"You do not have permission to access that page"
    end
  end
  
end
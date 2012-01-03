class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :mailer_set_url_options

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
  
  def after_sign_in_path_for(resource)
    if resource.is_admin?
      '/admin'
    else
      user_dashboard_path
    end
  end

  def build_objects_from_cookies
    @cart = {}
    @cart_seller_ids = Marshal.load(cookies["#{cookies["_hapful_session"]}-sellers".to_sym]) rescue []
    @cart_seller_ids.each do |seller_id|
      cart_contents = Marshal.load(cookies["#{cookies["_hapful_session"]}-#{seller_id}".to_sym]) rescue {}
      cart_contents.each do |k,v|
        product = Product.find(v[:product_id]) rescue next
        @cart[User.find(seller_id.to_i)] = []
        @cart[User.find(seller_id.to_i)] << v.merge({:product=>product})
      end
    end
  end
  
end

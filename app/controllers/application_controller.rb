class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :mailer_set_url_options

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def authenticate_user!
    session["user_return_to"] = request.fullpath
    super
  end

  def after_sign_in_path_for(resource)
    if resource.is_admin?
      '/admin'
    else
      stored_location_for(resource) || user_dashboard_path
    end
  end

  def build_objects_from_cookies
    @cart = {}
    @cart_seller_ids = Marshal.load(cookies["#{cookies["_hapful_session"]}-sellers".to_sym]) rescue []
    @cart_seller_ids.each do |seller_id|
      cart_contents = Marshal.load(cookies["#{cookies["_hapful_session"]}-#{seller_id}".to_sym]) rescue {}
      user = User.find(seller_id.to_i)
      @cart[user] = []
      cart_contents.each do |k,v|
        product = Product.find(v[:product_id]) rescue next
        variant = product.options.find(v[:product_option_id]) rescue ProductOption.new(:additional_cost=>0.0)
        @cart[user] << v.merge({:product=>product, :variant=>variant})
      end
    end
  end

  def cart_per_seller_from_cookie(seller)
    cart_contents.each do |k,v|
      product = Product.find(v[:product_id]) rescue next
      @cart[User.find(seller_id.to_i)] = []
      @cart[User.find(seller_id.to_i)] << v.merge({:product=>product})
    end
  end
  
end

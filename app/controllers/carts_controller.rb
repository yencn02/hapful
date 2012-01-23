class CartsController < ApplicationController

  def add
    @product = Product.find_by_slug(params[:product_slug])
    cart_sellers = Marshal.load(cookies["#{cookies["_hapful_session"]}-sellers".to_sym]) rescue []
    cart_contents = Marshal.load(cookies["#{cookies["_hapful_session"]}-#{@product.user_id}".to_sym]) rescue {}
    cart_sellers << @product.user_id
    cart_sellers.uniq!
    new_item_key = "p_#{@product.id}_v_#{params[:cart][:product_option_id]}"
    if cart_contents.keys.include?(new_item_key)
      cart_contents[new_item_key][:quantity] = if params[:change].eql?('down')
        cart_contents[new_item_key][:quantity].to_i - params[:cart][:quantity].to_i
      else
        params[:cart][:quantity].to_i + cart_contents[new_item_key][:quantity].to_i
      end
       
    else
      cart_contents[new_item_key]={
        :quantity=>params[:cart][:quantity].to_i,
        :product_option_id=>params[:cart][:product_option_id],
        :product_id=>@product.id
      }
    end
    
    cookies["#{cookies["_hapful_session"]}-#{@product.user_id}".to_sym] = {
      :value => Marshal.dump(cart_contents),
      :expires => 4.years.from_now
    }
    cookies["#{cookies["_hapful_session"]}-sellers".to_sym] = {
      :value => Marshal.dump(cart_sellers),
      :expires => 4.years.from_now
    }
    
    redirect_to show_cart_path
  end

  def show
    build_objects_from_cookies
    respond_to do |format|
      format.html{render :layout=>false if params[:cbed]}
      format.js {render :layout=>false}
    end
  end


  def remove_content

  end

end

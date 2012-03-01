class PagesController < ApplicationController
  
  def index
    @posts = Post.all
    @top_rateds = Product.top_rated
    @newly_addeds = Product.newly_added
    @most_viewed = Product.most_viewed
  end

  def market
    @top_rateds = Product.top_rated
    @newly_addeds = Product.newly_added
    @most_viewed = Product.most_viewed
  end

  def search
    per_page = ProjectConfig.value('show_per_page') || 25
    @products = Product.paginated_search(params[:search], params[:page], per_page)
    @result_count = Product.paginated_search_count(params[:search])
  end

  def seller
    @seller = User.find_by_username(params[:seller])
    @products = @seller.products
  end

  def order_tracking
    
  end

  def view_order_tracking
    order = Order.where({:email=>params[:track][:email], :reference_number=>params[:track][:reference_number]})
    if !order.empty?
      @order = order.first
    else
      flash[:error]="Please check your reference number and email"
      redirect_to order_tracking_url(params[:track][:reference_number])
    end
  end

  def by_category
    @category = Category.find(params[:id])
    @products = @category.products.paginate(:page=>params[:page], :per_page=>20)
  end

  def update_merch
    @user = current_user
    params[:user][:merchant_accounts_attributes].values.each do |values|
      merch = @user.merchant_accounts.for_type(values[:merchant_type]) || @user.merchant_accounts.build
      merch.attributes = values.delete_if{|k,v| k.to_s=='_destroy'}
    end
    msg = if @user.save
      @user.products.update_all("state='published'")
      {:notice=>"Thank you for adding your merchant details. You may now start linking your products to your blog posts!"}
    else
      {:error=>"#{@user.errors.full_messages.join(",")}"}
    end
    redirect_to(user_dashboard_path, msg)
  end

  def trial
    @user = session[:created_user].blank? ? User.new(params[:user]) : User.find(session[:created_user])
    @product = @user.products.new(params[:product])
    @product.images.build if @product.images.blank?
    if request.post?
      
      # work around for missing error messages for product
      @user.valid?
      @product.set_payment_options(params[:payopts]) if params[:payopts]
      @product.set_shipping_options(params[:shipopts]) if params[:shipopts]
      @product.valid?
      
      if @user.save
        session[:created_user] = @user.id
        @product.user_id = @user.id
        unless @product.use_hapful?
          @product.images = []
        end
        if @product.save
          flash[:success] = "Thank you for trying out Hapful"
          sign_in_and_redirect(:user, @user)
        end
      end
    end
  end


end

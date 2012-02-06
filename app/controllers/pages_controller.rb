class PagesController < ApplicationController
  
  def index
    @articles = Article.welcome
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
      {:notice=>"Thank you."}
    else
      {:error=>"#{@user.errors.full_messages.join(",")}"}
    end
    redirect_to(user_dashboard_path, msg)
  end

end

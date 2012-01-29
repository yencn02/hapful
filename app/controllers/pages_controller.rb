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

end

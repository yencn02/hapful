class PagesController < ApplicationController
  
  def index
    @articles = Article.welcome
  end

  def market
    @top_rateds = Product.top_rated
    @newly_addeds = Product.newly_added
    @most_viewed = Product.most_viewed
  end

end

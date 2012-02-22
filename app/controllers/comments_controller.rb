class CommentsController < ApplicationController
  before_filter :get_product

  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id if current_user
    if @comment.save
      redirect_to @product, :notice => 'Comment was successfully created.'
    else
      redirect_to @product, :alert => 'Comment could not be saved. Please fill in all fields'
    end
  end


  protected
  def get_product
    @product = Product.find(params[:product_id])
  end
end
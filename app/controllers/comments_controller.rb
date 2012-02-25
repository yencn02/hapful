class CommentsController < ApplicationController
  before_filter :get_product

  def index

  end
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id if current_user
    if @comment.save
      flash[:notice] = 'Comment was successfully created.'
      redirect_to product_comments_path @product
    else
      flash[:alert] = 'Comment could not be saved. Please fill in all fields'
      redirect_to product_comments_path @product
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy if comment
    flash[:notice] = "Comment was successfully deleted."
    redirect_to product_comments_path @product    
  end

  protected
  def get_product
    @product = Product.find(params[:product_id])
  end
end
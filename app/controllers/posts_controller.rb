class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def ajax_sort
    @posts = Post.sorted_from_params(params[:sort])
    data = ""
    @posts.each do |post|
      data << render_to_string(:partial=>"shared/show_post", :locals=>{:post=>post})
    end
    render :json=>{:data=>data}
  end
end
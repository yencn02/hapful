class ProductWidgetsController < ApplicationController
  before_filter :get_objects
  uses_yui_editor
  
  def edit
    @widget = @product.widget
    @content = @widget.content
  end

  def update
    @widget = @product.widget
    if @widget.update_attributes(params[:product_widget])
      redirect_to [@product], :notice=>"Widget updated."
    else
      render 'edit'
    end
  end

  def preview
    @widget = @product.widget
    @content = params[:content]
    render :layout=>false
  end

  def iframed
    @widget = @product.widget
    @content = @widget.content
    build_objects_from_cookies
    render :layout=>'frame'
  end
  
  private

  def get_objects
    @product = Product.find(params[:product_id])
  end


  

end

class ProductsController < ApplicationController

  before_filter :get_product, :except=>[:index, :new, :create]
  before_filter :user_access_restriction, :except=>[:index, :show, :new, :create]
  before_filter :merge_state_params, :only=>[:create, :update]

  def index
    if current_user
      @products = current_user.products
    else
      redirect_to market_path
    end
    render :layout=>false if params[:ajax]
  end

  def show
    @widget = @product.widget || @product.build_widget
    @content = @widget.content
    @demo = true if params[:demo]
    respond_to do |format|
      format.html
      format.js do
        @compiled_template = if @widget.embedded?
          render_to_string(:partial=>"product_widgets/embed")
        else
          render_to_string(:partial=>"product_widgets/colorbox")
        end
      end
    end
  end

  def new
    @product = current_user.products.new
    @product.images.build
    @product.options.build
    @product.build_widget
  end

  def edit
  end

  def create
    @product = current_user.products.new(params[:product])
    set_product_behavior
    respond_to do |format|
      if @product.save()
        format.html { redirect_to(@product, :notice => 'Product was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    set_product_behavior
    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end

  def demo
    render :layout=>'frame'
  end
  

  private

  def get_product
    @product = Product.find(params[:id])
  end

  def user_access_restriction
    unless current_user == @product.user
      redirect_to request.referrer, :notice=>"You don't have access here"
    end
  end

  def merge_state_params
    state = if params[:commit].eql?("Save as Draft")
      {:state => "saved" }
    else
      {:state => "published" }
    end
    params[:product].merge!(state)
  end

  def set_shipping_and_payment
    @product.set_payment_options(params[:payopts]) if params[:payopts]
    @product.set_shipping_options(params[:shipopts]) if params[:shipopts]
  end

  def set_product_behavior
    if @product.use_hapful? || params[:product][:use_hapful].eql?('1')
      set_shipping_and_payment
    else
      @product.images = []
    end
  end

end

class Admin::ProductsController < Admin::BaseController
  def index
    @products = Product.paginate(:page=>params[:page], :per_page=>15, :order=>"state desc")
    @deleted_products = Product.deleted
  end

  def destroy
    @product = Product.find(params[:id])
    @product.mark_as_deleted!
    redirect_to [:admin, :products]
  end
  
end
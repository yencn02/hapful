class Admin::ShippingOptionsController < Admin::BaseController
  
  def index
    @shipping_options = ShippingOption.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shipping_options }
    end
  end

  def show
    @shipping_option = ShippingOption.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @shipping_option }
    end
  end

  def new
    @shipping_option = ShippingOption.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shipping_option }
    end
  end

  def edit
    @shipping_option = ShippingOption.find(params[:id])
  end

  def create
    @shipping_option = ShippingOption.new(params[:shipping_option])

    respond_to do |format|
      if @shipping_option.save
        format.html { redirect_to([:admin, @shipping_option], :notice => 'Shipping option was successfully created.') }
        format.xml  { render :xml => @shipping_option, :status => :created, :location => @shipping_option }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shipping_option.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @shipping_option = ShippingOption.find(params[:id])

    respond_to do |format|
      if @shipping_option.update_attributes(params[:shipping_option])
        format.html { redirect_to([:admin, @shipping_option], :notice => 'Shipping option was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shipping_option.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @shipping_option = ShippingOption.find(params[:id])
    @shipping_option.destroy

    respond_to do |format|
      format.html { redirect_to([:admin, :shipping_options]) }
      format.xml  { head :ok }
    end
  end
end
